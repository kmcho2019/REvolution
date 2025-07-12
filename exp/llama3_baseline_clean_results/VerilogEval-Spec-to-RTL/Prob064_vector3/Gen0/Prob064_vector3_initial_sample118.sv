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

    wire [29:0] concat;
    wire [31:0] padded;

    assign concat = {a, b, c, d, e, f};
    assign padded = {concat, 2'b11};

    assign w = padded[31:24];
    assign x = padded[23:16];
    assign y = padded[15:8];
    assign z = padded[7:0];

endmodule