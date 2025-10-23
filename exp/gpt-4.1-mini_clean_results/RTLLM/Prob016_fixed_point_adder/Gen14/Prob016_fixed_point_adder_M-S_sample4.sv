module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bit width (including sign)
)(
    input  wire [N-1:0] a,          // First fixed-point operand
    input  wire [N-1:0] b,          // Second fixed-point operand
    output reg  [N-1:0] c           // Result of fixed-point addition
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values (clear MSB)
    wire [N-2:0] a_abs = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_abs = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    reg [N-2:0] res_abs;
    reg res_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            {res_sign, res_abs} = {1'b0, a_abs} + {1'b0, b_abs};
            res_sign = a_sign; // sign stays the same as operands
        end else begin
            // Different signs: subtract smaller from larger abs
            if (a_abs > b_abs) begin
                res_abs = a_abs - b_abs;
                res_sign = a_sign;
            end else if (b_abs > a_abs) begin
                res_abs = b_abs - a_abs;
                res_sign = b_sign;
            end else begin
                // Equal magnitudes => result is zero
                res_abs = 0;
                res_sign = 1'b0; // positive zero
            end
        end

        // Assign output: sign bit + abs value
        // If overflow in addition, res_abs may be wider; truncate if needed
        c = {res_sign, res_abs[N-2:0]};
    end

endmodule