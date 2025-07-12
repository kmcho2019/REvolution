module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Parameter validation (synthesizable)
    generate
        if (Q >= N) begin
            // This will cause elaboration error if Q >= N
            illegal_parameter_combination illegal();
        end
    endgenerate

    // Internal signed representation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Full precision addition
    wire signed [N:0] sum_full = a_signed + b_signed;

    // Overflow occurs when sign bits don't match and result sign differs from inputs
    wire overflow = (a[N-1] == b[N-1]) && (sum_full[N] != a[N-1]);

    // Saturation value
    wire signed [N-1:0] max_val = {1'b0, {(N-1){1'b1}};
    wire signed [N-1:0] min_val = {1'b1, {(N-1){1'b0}};

    // Final result with saturation
    assign c = overflow ? 
              (a[N-1] ? min_val : max_val) :  // Saturate to min/max
              sum_full[N-1:0];                 // Normal result

endmodule