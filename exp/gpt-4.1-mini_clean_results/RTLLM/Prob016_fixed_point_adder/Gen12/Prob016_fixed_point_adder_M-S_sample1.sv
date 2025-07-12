module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits
    parameter integer N = 16       // Total bit width (including sign)
)(
    input  wire [N-1:0] a,         // First fixed-point operand
    input  wire [N-1:0] b,         // Second fixed-point operand
    output reg  [N-1:0] c          // Result of fixed-point addition
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values (two's complement if negative)
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values, keep sign
            // Add with carry out discarded
            c[N-2:0] = a_abs[N-2:0] + b_abs[N-2:0];
            c[N-1]   = a_sign;
        end else begin
            // Different sign: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                // a_abs >= b_abs: result positive sign if a is positive or negative sign if a negative?
                // According to instructions: 
                // "If a > b, result = a - b, MSB = 0 (positive)"
                // So sign = 0 here regardless of a_sign?
                // But if a is negative and b positive and abs(a) > abs(b), then result sign?
                // Following instruction exactly: MSB=0 if a_abs >= b_abs in diff sign case
                c[N-2:0] = a_abs[N-2:0] - b_abs[N-2:0];
                c[N-1]   = 1'b0;
            end else begin
                // b_abs > a_abs: result = b - a, MSB set to 0 if zero else 1 (negative)
                // Check zero
                if (b_abs == a_abs) begin
                    c = {N{1'b0}}; // zero with positive sign
                end else begin
                    c[N-2:0] = b_abs[N-2:0] - a_abs[N-2:0];
                    c[N-1]   = 1'b1;
                end
            end
        end
    end

endmodule