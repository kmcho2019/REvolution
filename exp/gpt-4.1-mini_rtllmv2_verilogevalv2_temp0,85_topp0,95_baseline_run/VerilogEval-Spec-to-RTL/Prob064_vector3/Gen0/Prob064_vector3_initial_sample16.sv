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
    wire [31:0] concatenated;

    assign concatenated = {a, b, c, d, e, f, 2'b11};

    // Since inputs total 30 bits, and we add 2 bits at LSB, the order is:
    // MSB: a[4:0], b[4:0], c[4:0], d[4:0], e[4:0], f[4:0], then 2'b11 LSB
    // So concatenated[31:2] = {a,b,c,d,e,f} (30 bits)
    // concatenated[1:0] = 2'b11

    assign w = concatenated[31:24];
    assign x = concatenated[23:16];
    assign y = concatenated[15:8];
    assign z = concatenated[7:0];

endmodule