module TopModule(
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

    // Directly assign outputs by concatenating inputs and constant bits without intermediate wire
    assign w = {a, b[4:2]};       // 5 bits from a and upper 3 bits from b
    assign x = {b[1:0], c, d[4]}; // lower 2 bits of b, all 5 bits c, and 1 bit from d
    assign y = {d[3:0], e[4:1]};  // lower 4 bits d and upper 4 bits e
    assign z = {e[0], f, 2'b11};  // lowest bit e, all 5 bits f, and two constant '1's

endmodule