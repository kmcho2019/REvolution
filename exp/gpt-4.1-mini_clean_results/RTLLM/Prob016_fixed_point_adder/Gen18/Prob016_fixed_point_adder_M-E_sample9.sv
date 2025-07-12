module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total bits (including sign bit)
)(
    input  wire signed [N-1:0] a,   // First fixed-point operand (two's complement)
    input  wire signed [N-1:0] b,   // Second fixed-point operand (two's complement)
    output reg  signed [N-1:0] c    // Result fixed-point sum (two's complement)
);

    // Internal signals
    wire signed [N-1:0] sum;        // Raw sum of a and b

    // Saturation constants
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // Largest positive number
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // Most negative number (two's complement min)

    // Perform addition
    assign sum = a + b;

    always @(*) begin
        // Overflow detection:
        // Overflow occurs if:
        // - a and b have same sign, but sum sign differs
        // - specifically:
        //    positive overflow if a>0, b>0, sum<0
        //    negative overflow if a<0, b<0, sum>=0

        if ((a[N-1] == 1'b0) && (b[N-1] == 1'b0) && (sum[N-1] == 1'b1)) begin
            // Positive overflow
            c = MAX_VAL;
        end else if ((a[N-1] == 1'b1) && (b[N-1] == 1'b1) && (sum[N-1] == 1'b0)) begin
            // Negative overflow
            c = MIN_VAL;
        end else begin
            // No overflow
            c = sum;
        end
    end

endmodule