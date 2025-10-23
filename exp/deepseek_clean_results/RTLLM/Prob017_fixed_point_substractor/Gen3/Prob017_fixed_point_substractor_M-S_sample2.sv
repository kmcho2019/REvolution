module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform the subtraction directly
    wire [N-1:0] raw_result = a - b;
    
    // Handle zero case explicitly (set sign bit to 0)
    assign c = (raw_result[N-2:0] == 0) ? {1'b0, {N-1{1'b0}}} : raw_result;

endmodule