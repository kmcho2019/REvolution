module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Perform two's complement subtraction
    wire [N:0] extended_result;
    assign extended_result = {a[N-1], a} - {b[N-1], b};
    
    // Detect overflow (occurs when signs don't match)
    assign overflow = (extended_result[N] != extended_result[N-1]);
    
    // Final result (truncate to N bits) with explicit zero handling
    assign c = (extended_result[N-1:0] == {N{1'b0}}) ? {N{1'b0}} : extended_result[N-1:0];

endmodule