module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N-1:0] res;
    reg a_sign, b_sign;
    reg res_sign;

    always @(*) begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];
        
        // Compute absolute values
        abs_a = a_sign ? (~a + 1'b1) : a;
        abs_b = b_sign ? (~b + 1'b1) : b;
        
        if (a_sign == b_sign) begin
            // Same signs: perform addition
            res = abs_a + abs_b;
            res_sign = a_sign;
        end else begin
            // Different signs: perform subtraction
            if (abs_a > abs_b) begin
                res = abs_a - abs_b;
                res_sign = a_sign;
            end else if (abs_b > abs_a) begin
                res = abs_b - abs_a;
                res_sign = b_sign;
            end else begin
                // Equal magnitudes, result is zero
                res = {N{1'b0}};
                res_sign = 1'b0;
            end
        end
        
        // Apply sign to result
        c = res_sign ? (~res + 1'b1) : res;
    end

endmodule