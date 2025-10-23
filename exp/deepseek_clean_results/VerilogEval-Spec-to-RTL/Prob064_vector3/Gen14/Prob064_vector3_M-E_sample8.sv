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

    // Create the 32-bit combined value with padding
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};

    // Extract each 8-bit output by selecting different segments
    assign w = combined[31:24];  // First 8 bits (a + part of b)
    assign x = combined[23:16];  // Next 8 bits (rest of b + c + part of d)
    assign y = combined[15:8];    // Next 8 bits (rest of d + part of e)
    assign z = combined[7:0];     // Last 8 bits (rest of e + f + padding)

endmodule