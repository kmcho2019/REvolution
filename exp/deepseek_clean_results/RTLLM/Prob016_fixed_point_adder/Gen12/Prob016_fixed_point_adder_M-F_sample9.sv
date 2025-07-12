module fixed_point_adder #(
    parameter Q = 8,            // Number of fractional bits
    parameter N = 16,           // Total number of bits
    parameter ENABLE_OVERFLOW = 1  // Enable overflow detection
) (
    input wire [N-1:0] a,       // First fixed-point operand
    input wire [N-1:0] b,       // Second fixed-point operand
    output wire [N-1:0] c,      // Fixed-point result
    output wire overflow        // Overflow indicator (optional)
);

    // Parameter validation - synthesis compatible
    generate
        if (Q >= N) begin
            // This will cause elaboration error if Q >= N
            illegal_parameter_condition illegal();
        end
    endgenerate

    // Internal signed representation with explicit width
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);
    
    // Perform signed addition with explicit width control
    wire signed [N-1:0] sum;
    assign sum = a_signed + b_signed;
    
    // Assign result
    assign c = sum[N-1:0];
    
    // Conditional overflow detection
    generate
        if (ENABLE_OVERFLOW) begin
            assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                            (sum[N-1] != a_signed[N-1]);
        end else begin
            assign overflow = 1'b0;
        end
    endgenerate

endmodule