module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    localparam PAD = 2'b11;
    wire signed [31:0] combined = {a, b, c, d, e, f, PAD};

    assign w[7:0] = combined[31:24];
    assign x[7:0] = combined[23:16];
    assign y[7:0] = combined[15:8];
    assign z[7:0] = combined[7:0];

endmodule