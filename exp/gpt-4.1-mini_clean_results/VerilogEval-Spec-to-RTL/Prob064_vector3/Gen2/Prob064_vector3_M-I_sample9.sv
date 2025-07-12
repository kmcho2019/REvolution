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

    // Directly assign outputs by concatenating parts of inputs and constant bits
    // Concatenate inputs in order: a,b,c,d,e,f -> 30 bits
    // Then append 2'b11 at LSB to make 32 bits
    // Assign each output an 8-bit slice of this 32-bit vector without intermediate wire

    assign w = {a, b}[29:22];               // bits 31-24 -> upper bits from a,b,c,... will fill these, so take correct bits
    assign x = {a, b, c, d, e, f, 2'b11}[23:16];
    assign y = {a, b, c, d, e, f, 2'b11}[15:8];
    assign z = {a, b, c, d, e, f, 2'b11}[7:0];

endmodule