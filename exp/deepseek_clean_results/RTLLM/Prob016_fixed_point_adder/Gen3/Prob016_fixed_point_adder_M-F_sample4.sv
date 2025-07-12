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
    reg a_sign, b_sign;

    always @(*) begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];
        
        // Get absolute values (magnitudes)
        abs_a = a_sign ? -a : a;
        abs_b = b_sign ? -b : b;
        
        // Determine operation based on signs
        if (a_sign == b_sign) begin
            // Same signs: add magnitudes
            res = abs_a + abs_b;
            // Maintain original sign
            res[N-1] = a_sign;
        end
        else begin
            // Different signs: subtract smaller from larger
            if (abs_a > abs_b) begin
                res = abs_a - abs_b;
                res[N-1] = a_sign;
            end
            else begin
                res = abs_b - abs_a;
                res[N-1] = b_sign;
            end
        end
        
        // Basic overflow handling (truncation)
        c = res;
        
        // Overflow detection (optional)
        if (a_sign == b_sign && res[N-1] != a_sign) begin
            // Overflow occurred - saturate to max/min value
            c = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
        end
    end

endmodule