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

    wire [31:0] concat_with_ones;
    // Place the two '1' bits as the MSBs, then concatenate inputs
    assign concat_with_ones = {2'b11, a, b, c, d, e, f};

    // Split into 8-bit outputs: w is MSB, z is LSB
    assign w = concat_with_ones[31:24];
    assign x = concat_with_ones[23:16];
    assign y = concat_with_ones[15:8];
    assign z = concat_with_ones[7:0];

endmodule