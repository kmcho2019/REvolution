module TopModule(
    input  [3:0] x,
    output      f
);
    // Assign input bits to named variables for clarity
    // According to problem:
    // Row index = x[2] x[3]
    // Column index = x[0] x[1]
    // So inputs: a = x[3], b = x[2], c = x[1], d = x[0]
    wire a = x[3];
    wire b = x[2];
    wire c = x[1];
    wire d = x[0];

    // From the K-map:
    // Rows: b a  (x[2] x[3])
    // Cols: d c  (x[0] x[1])
    // But bits a and b are x[3], x[2], so rows = {b,a} means {x[2], x[3]} per problem.
    // Columns = {d,c} = {x[0], x[1]}

    // Let's rewrite the K-map here for clarity (rows b a = x[2] x[3], cols d c = x[0] x[1]):
    //           dc
    //     00  01  11  10
    // ba +----------------
    // 00 | 1 | 0 | 0 | 1 |
    // 01 | 0 | 0 | 0 | 0 |
    // 11 | 1 | 1 | 1 | 0 |
    // 10 | 1 | 1 | 0 | 1 |

    // Let's find groups to simplify:
    // Group 1: Column 00, rows 00,11,10 => covers f=1 at (00,00), (11,00), (10,00)
    // Group 2: Column 01, rows 11,10 => f=1 at (11,01),(10,01)
    // Group 3: Column 10, rows 00,10 => f=1 at (00,10), (10,10)
    // Group 4: Row 11 columns 00,01,11 => f=1 at (11,00),(11,01),(11,11)

    // Extract terms:
    // Term A: d' c' (column 00)
    // Row indices for term A: (00,11,10) => b=0 or b=1, a=0 or 1
    // So no restriction on b or a => term is d' c'
    // But the zeros at row 01, column 00: f=0 at (01,00) means this term covers rows 00,10,11, excluding 01

    // Term B: d' c  (column 01), rows 11,10 (b=1, a=0 or 1)
    // So b=1, no restriction on a, d'=1, c=1

    // Term C: d c'  (column 10), rows 00,10 (b=0 or 1, a=0)
    // So a=0, d=1, c=0

    // Term D: row 11 (b=1, a=1), columns 00,01,11 (d c combinations 00,01,11)
    // This means b=1, a=1, and (d c != 10) (since at (11,10) = 0)
    // So b=1, a=1, and not (d=1, c=0) → (d' + c) to exclude 10
    // So term D: b a (d' + c)

    // The simplified function is:
    // f = d' c' + b d' c + a' d c' + b a (d' + c)

    // Let's express the terms in Verilog:

    wire term1 = ~d & ~c;           // d' c'
    wire term2 = b & ~d & c;        // b d' c
    wire term3 = ~a & d & ~c;       // a' d c'
    wire term4 = b & a & (~d | c);  // b a (d' + c)

    assign f = term1 | term2 | term3 | term4;
endmodule