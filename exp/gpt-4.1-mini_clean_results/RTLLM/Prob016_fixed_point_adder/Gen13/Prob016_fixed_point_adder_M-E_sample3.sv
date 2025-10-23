module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits
    parameter integer N = 16       // Total bit width (including sign)
)(
    input  wire [N-1:0] a,         // First fixed-point operand
    input  wire [N-1:0] b,         // Second fixed-point operand
    output reg  [N-1:0] c          // Result of fixed-point addition
);

    // Declare signed versions of inputs to perform signed arithmetic
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Perform signed addition
    wire signed [N:0] sum_wide; // one bit wider to detect overflow if needed

    assign sum_wide = a_signed + b_signed;

    always @(*) begin
        // Assign lower N bits of sum_wide to output (truncate overflow)
        c = sum_wide[N-1:0];
    end

endmodule