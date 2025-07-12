module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Two's complement subtraction (handles all sign cases)
    wire [N-1:0] raw_diff = a - b;
    wire [N-2:0] result_mag = raw_diff[N-2:0];

    // Hierarchical zero detection (tree structure)
    wire [7:0] zero_chunks;
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin
            assign zero_chunks[i] = |result_mag[i*4 +: 4];
        end
    endgenerate
    wire is_zero = ~(|zero_chunks);

    // Sign determination using arithmetic properties
    wire result_sign = raw_diff[N-1];

    // Final output assembly with zero handling
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : 
               {result_sign, result_mag};

endmodule