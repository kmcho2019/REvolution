module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal register as specified
    reg [N-1:0] res;
    reg [N-1:0] abs_a, abs_b;
    reg sign_a, sign_b;
    reg res_sign;

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];
        
        // Get absolute values (magnitudes)
        abs_a = sign_a ? -a : a;
        abs_b = sign_b ? -b : b;
        
        // Perform appropriate operation based on signs
        if (sign_a == sign_b) begin
            // Same signs: add magnitudes
            res = abs_a + abs_b;
            res_sign = sign_a;  // Result has same sign
        end
        else begin
            // Different signs: subtract smaller from larger
            if (abs_a > abs_b) begin
                res = abs_a - abs_b;
                res_sign = sign_a;
            end
            else begin
                res = abs_b - abs_a;
                res_sign = (abs_b == abs_a) ? 1'b0 : sign_b;
            end
        end
        
        // Apply sign to result
        c = res_sign ? -res : res;
        
        // Overflow handling (truncation)
        if (sign_a == sign_b && sign_a != c[N-1]) begin
            // Overflow occurred - saturate to max/min value
            c = sign_a ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
        end
    end

endmodule