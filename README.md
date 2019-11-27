#  GSVConverter

## Covert GSV Files to GSON Files and vice versa

### GSVConverter input-url output-file

-input file can be anywhere
-output file must be local, either csv or json will be appended as appropriate
-files will be validated for GSV consistency and GSON Conformity

#### CSV 
    ":title:","bleeblah"
    ":subtitle:","blooblah"
    ":author:",":billdonner"
    ":fields:","c1","c2","c3"
    ":r1:","r1c1","r1c2"
    ":r2:","r2c1","r2c2","r2c3"

#### JSON
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
