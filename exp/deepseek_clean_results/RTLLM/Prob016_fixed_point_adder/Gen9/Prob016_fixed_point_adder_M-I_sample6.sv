module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude representations (absolute values)
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Arithmetic operations
    wire [N:0] sum_full = {1'b0, a_abs} + {1'b0, b_abs};  // Extra bit for carry
    wire [N:0] diff_full = {1'b0, a_abs} - {1'b0, b_abs};  // Signed difference

    // Result selection
    reg [N-1:0] result;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same signs: add magnitudes
            result = {a_sign, sum_full[N-2:0]};
        end else begin
            // Different signs: subtract smaller from larger
            if (diff_full[N]) begin  // b > a
                result = {b_sign, diff_full[N-2:0]};
            end else begin           // a >= b
                result = {a_sign, diff_full[N-2:0]};
            end
        end
    end

    // Overflow detection and saturation
    wire overflow = (a_sign == b_sign) & sum_full[N];
    assign c = overflow ? 
               {a_sign, {(N-1){~a_sign}}} :  // Saturate to max/min
               result;                      // Normal result

endmodule