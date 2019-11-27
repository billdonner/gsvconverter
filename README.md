#  GSVConverter

GSV Assets are bundled:

<pre><code>
struct PlayData:Codable, Equatable {
  let title: String
  let subtitle: String
  let author: String
  let headers: [String]
  let data: [[String]]
}
</code></pre>  

## Covert GSV Files to GSON Files and vice versa

Either representation of assets can be utilized to fill the data model 



### GSVConverter input-url output-file

-input file can be anywhere
-output file must be local, either csv or json will be appended as appropriate
-files will be validated for GSV consistency and GSON Conformity

#### GSV 

GSV is Constrained CSV with  multiple header lines that must all be present

    ":title:","bleeblah"
    ":subtitle:","blooblah"
    ":author:",":billdonner"
    ":fields:","c1","c2","c3"
    ":r1:","r1c1","r1c2"
    ":r2:","r2c1","r2c2","r2c3"

#### GSON

GSON is plain JSON with all required fields. The data rows correspond directly to the GSV Rows
<pre><code>
{
  "author" : ":billdonner",
  "title" : "bleeblah",
  "headers" : [
    "c1",
    "c2",
    "c3"
  ],
  "subtitle" : "blooblah",
  "data" : [
    [
      "r1c1",
      "r1c2"
    ],
    [
      "r2c1",
      "r2c2",
      "r2c3"
    ]
  ]
}
</code></pre>
