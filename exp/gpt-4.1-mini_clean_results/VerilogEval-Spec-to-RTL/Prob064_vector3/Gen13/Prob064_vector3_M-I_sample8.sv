module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Directly assign outputs by concatenating inputs without intermediate wires
    // Order inputs as (a,b,c,d,e,f) with appended '11' in the last output's LSBs
    assign w = {a, b[4:1]};             // 5 bits of a + top 4 bits of b
    assign x = {b[0], c, d[4:2]};       // lowest bit of b + c + top 3 bits of d
    assign y = {d[1:0], e, f[4]};       // bottom 2 bits of d + e + top bit of f
    assign z = {f[3:0], 2'b11};          // bottom 4 bits of f + appended '11'

endmodule