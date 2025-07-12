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

    // Create the full 32-bit concatenated value
    wire [31:0] full_concat = {a, b, c, d, e, f, 2'b11};

    // Extract each 8-bit output using bit selects
    assign w = full_concat[31:24];
    assign x = full_concat[23:16];
    assign y = full_concat[15:8];
    assign z = full_concat[7:0];

endmodule