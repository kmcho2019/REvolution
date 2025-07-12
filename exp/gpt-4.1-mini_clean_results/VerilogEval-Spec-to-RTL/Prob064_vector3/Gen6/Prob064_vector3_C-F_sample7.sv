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

    // Concatenate all inputs into 30 bits and append two LSB '1' bits as 32-bit vector,
    // then assign slices directly to each 8-bit output without intermediate wires.
    assign w = {a, b, c, d, e, f, 2'b11}[31:24];
    assign x = {a, b, c, d, e, f, 2'b11}[23:16];
    assign y = {a, b, c, d, e, f, 2'b11}[15:8];
    assign z = {a, b, c, d, e, f, 2'b11}[7:0];

endmodule