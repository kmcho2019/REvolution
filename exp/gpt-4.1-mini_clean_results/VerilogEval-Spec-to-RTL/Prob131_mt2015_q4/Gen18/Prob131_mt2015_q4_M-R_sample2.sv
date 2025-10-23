module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy = x ^ y;
    wire inv_xor_xy = ~xor_xy;

    // Single instance equivalent output for A: z = (x ^ y) & x
    wire a_out;
    assign a_out = xor_xy & x;

    // Single instance equivalent output for B: z = ~(x ^ y)
    wire b_out;
    assign b_out = inv_xor_xy;

    // Replicate outputs for pairs:
    wire a_out_0 = a_out;
    wire a_out_1 = a_out;
    wire b_out_0 = b_out;
    wire b_out_1 = b_out;

    // Compute combined signals as per original structure:
    wire or_out = a_out_0 | b_out_0;
    wire and_out = a_out_1 & b_out_1;

    // Final output z
    assign z = or_out ^ and_out;
endmodule