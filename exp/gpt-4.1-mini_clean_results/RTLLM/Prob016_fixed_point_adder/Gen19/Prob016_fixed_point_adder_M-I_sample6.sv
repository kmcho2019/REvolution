module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total bits (including sign bit)
)(
    input  wire signed [N-1:0] a,   // First fixed-point operand (two's complement)
    input  wire signed [N-1:0] b,   // Second fixed-point operand (two's complement)
    output reg  signed [N-1:0] c    // Result fixed-point sum (two's complement)
);

    // Internal register to store the result
    reg signed [N-1:0] res;

    // Saturation constants
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // Max positive value
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // Min negative value

    // Intermediate sum
    wire signed [N-1:0] sum = a + b;

    always @(*) begin
        // Check overflow conditions:
        // - If both inputs positive and sum negative => positive overflow
        // - If both inputs negative and sum positive => negative overflow
        if ((a[N-1] == 1'b0) && (b[N-1] == 1'b0) && (sum[N-1] == 1'b1)) begin
            res = MAX_VAL;
        end else if ((a[N-1] == 1'b1) && (b[N-1] == 1'b1) && (sum[N-1] == 1'b0)) begin
            res = MIN_VAL;
        end else begin
            res = sum;
        end

        c = res;
    end

endmodule