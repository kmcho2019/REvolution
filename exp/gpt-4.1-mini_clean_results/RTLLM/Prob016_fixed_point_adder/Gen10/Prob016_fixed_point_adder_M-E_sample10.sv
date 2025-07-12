module fixed_point_adder #(
    parameter integer N = 16,   // Total bits including sign bit
    parameter integer Q = 8     // Number of fractional bits (for interface clarity)
)(
    input  wire [N-1:0] a,     // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,     // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c      // Fixed-point output result
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform addition as signed addition with one extra bit for overflow detection
    wire signed [N:0] sum_ext = a_signed + b_signed;

    // Detect overflow: occurs if sign of inputs are same but sign of sum differs
    wire overflow = (~(a[N-1] ^ b[N-1])) & (a[N-1] ^ sum_ext[N-1]);

    // Define saturating limits
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};        // Max positive number
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};        // Most negative number

    // Internal register to store result
    reg signed [N-1:0] res;

    always @(*) begin
        if (overflow) begin
            // Saturate result based on sign of inputs (since inputs have same sign)
            if (a[N-1] == 1'b0)       // Positive overflow
                res = MAX_VAL;
            else                      // Negative overflow
                res = MIN_VAL;
        end else begin
            // No overflow, assign truncated sum
            res = sum_ext[N-1:0];
        end
    end

    // Assign output
    always @(*) begin
        c = res;
    end

endmodule