# frozen_string_literal: true

module LicenseFinder
  class License
    module Definitions
      extend self

      def all
        [
          apache2,
          apache2title,
          bsd,
          bsd2,
          cc01,
          gplv2,
          gplv3,
          isc_long,
          lgpl,
          mit,
          mpl2,
          newbsd,
          python,
          ruby,
          simplifiedbsd
        ]
      end

      def build_unrecognized(name)
        License.new(
          short_name: name,
          url: nil,
          matcher: NoneMatcher.new
        )
      end

      private

      def apache2
        License.new(
          short_name:  'Apache2',
          pretty_name: 'Apache 2.0',
          other_names: [
            'Apache-2.0',
            'Apache Software License',
            'Apache License 2.0',
            'Apache License Version 2.0',
            'Apache Public License 2.0',
            'Apache Software License, Version 2.0',
            'Apache 2',
            'Apache License',
            'Apache License, Version 2.0'
          ],
          url:         'http://www.apache.org/licenses/LICENSE-2.0.txt'
        )
      end

      def apache2title
        License.new(
          short_name:  'Apache2title',
          pretty_name: 'Apache 2.0',
          url:         'http://www.apache.org/licenses/LICENSE-2.0.txt'
        )
      end

      def bsd
        License.new(
          short_name:  'BSD',
          other_names: ['BSD4', 'bsd-old', '4-clause BSD', 'BSD-4-Clause', 'BSD License'],
          url:         'http://en.wikipedia.org/wiki/BSD_licenses#4-clause_license_.28original_.22BSD_License.22.29'
        )
      end

      def bsd2
        template = Template.named('BSD2')
        alternative = template.content.gsub(
          'IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE',
          'IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE'
        )
        # templates = ['BSD2', 'BSD2_holder', 'BSD2_no_star'] .map {|t| Template.named(t)}
        # alternatives = templates .map { |t| t.content.gsub(
        #   'IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE',
        #   'IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE'
        # )}

        # matcher = AnyMatcher.new(
        #   *templates .map {|t| Matcher.from_template(t)},
        #   *alternatives .map {|t| Matcher.from_text(t)},
        # )
        matcher = AnyMatcher.new(
          Matcher.from_template(template),
          Matcher.from_text(alternative)
        )

        License.new(
          short_name:  'BSD2',
          pretty_name: '2-clause BSD',
          other_names: ['BSD-2', 'Simplified BSD License', '2-clause BSD', 'BSD-2-Clause', 'FreeBSD License'],
          url:         'https://en.wikipedia.org/wiki/BSD_licenses#2-clause_license_(%22Simplified_BSD_License%22_or_%22FreeBSD_License%22)',
          matcher:     matcher
        )
      end

      def cc01
        License.new(
          short_name:  'CC01',
          pretty_name: 'CC0 1.0 Universal',
          other_names: ['CC0 1.0'],
          url:         'http://creativecommons.org/publicdomain/zero/1.0'
        )
      end

      def gplv2
        License.new(
          short_name:  'GPLv2',
          other_names: ['GPL V2', 'gpl-v2', 'GNU GENERAL PUBLIC LICENSE Version 2'],
          url:         'http://www.gnu.org/licenses/gpl-2.0.txt'
        )
      end

      def gplv3
        License.new(
          short_name:  'GPLv3',
          other_names: ['GPL V3', 'gpl-v3', 'GNU GENERAL PUBLIC LICENSE Version 3'],
          url:         'http://www.gnu.org/licenses/gpl-3.0.txt'
        )
      end

      # short version with only the first paragraph. All Go deps currently match the long version
      def isc
        License.new(
          short_name: 'ISC',
          url:        'http://en.wikipedia.org/wiki/ISC_license'
        )
      end

      def isc_long
        template = Template.named('ISC_long')
        alternate_content = template.content.gsub(
          # accept 'and' instead of 'and/or'
          'Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.',
          'Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.',
        )

        matcher = AnyMatcher.new(
          Matcher.from_template(template),
          Matcher.from_text(alternate_content)
        )

        License.new(
          short_name: 'ISC',
          url:        'http://en.wikipedia.org/wiki/ISC_license',
          matcher:    matcher,
        )
      end

      def lgpl
        License.new(
          short_name:  'LGPL',
          other_names: ['LGPL-3', 'LGPLv3', 'LGPL-3.0'],
          url:         'http://www.gnu.org/licenses/lgpl.txt'
        )
      end

      def mit
        url_regexp = %r{MIT Licen[sc]e.*http://(?:www\.)?opensource\.org/licenses/mit-license}
        header_regexp = /The MIT Licen[sc]e/
        one_liner_regexp = /is released under the MIT licen[sc]e/

        matcher = AnyMatcher.new(
          Matcher.from_template(Template.named('MIT')),
          Matcher.from_regex(url_regexp),
          HeaderMatcher.new(Matcher.from_regex(header_regexp)),
          Matcher.from_regex(one_liner_regexp)
        )

        License.new(
          short_name:  'MIT',
          other_names: ['Expat', 'MIT license', 'MIT License'],
          url:         'http://opensource.org/licenses/mit-license',
          matcher:     matcher
        )
      end

      def mpl2
        header_regexp = /Mozilla Public Licen[sc]e, version 2.0/

        matcher = AnyMatcher.new(
          Matcher.from_template(Template.named('MPL2')),
          HeaderMatcher.new(Matcher.from_regex(header_regexp))
        )

        License.new(
          short_name:  'MPL2',
          pretty_name: 'Mozilla Public License 2.0',
          other_names: [
            'MPL-2.0',
            'Mozilla Public License, Version 2.0'
          ],
          url:         'https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt',
          matcher:     matcher
        )
      end

      def newbsd
        templates = ['NewBSD', 'NewBSD_no_star'] .map {|t| Template.named(t)}
        alternatives = templates .map { |t| t.content.gsub(
          'Neither the name of <organization> nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.',
          'The names of its contributors may not be used to endorse or promote products derived from this software without specific prior written permission.'
        )}

        matcher = AnyMatcher.new(
          *templates .map {|t| Matcher.from_template(t)},
          *alternatives .map {|t| Matcher.from_text(t)},
        )

        License.new(
          short_name:  'NewBSD',
          pretty_name: 'New BSD',
          other_names: ['Modified BSD', 'BSD3', 'BSD-3', '3-clause BSD', 'BSD-3-Clause'],
          url:         'http://opensource.org/licenses/BSD-3-Clause',
          matcher:     matcher
        )
      end

      def python
        License.new(
          short_name:  'Python',
          pretty_name: 'Python Software Foundation License',
          other_names: ['PSF'],
          url:         'http://hg.python.org/cpython/raw-file/89ce323357db/LICENSE'
        )
      end

      def ruby
        url = 'http://www.ruby-lang.org/en/LICENSE.txt'

        matcher = AnyMatcher.new(
          Matcher.from_template(Template.named('Ruby')),
          Matcher.from_text(url)
        )

        License.new(
          short_name:  'Ruby',
          pretty_name: 'ruby',
          url:         url,
          matcher:     matcher
        )
      end

      def simplifiedbsd
        License.new(
          short_name:  'SimplifiedBSD',
          pretty_name: 'Simplified BSD',
          other_names: ['FreeBSD', '2-clause BSD', 'BSD-2-Clause', 'BSD 2-Clause'],
          url:         'http://opensource.org/licenses/bsd-license'
        )
      end
    end
  end
end
