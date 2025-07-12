module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg signed [N-1:0] abs_a;
    reg signed [N-1:0] abs_b;
    reg signed [N-1:0] res;
    reg a_sign, b_sign;

    always @(*) begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];
        
        // Calculate absolute values
        abs_a = a_sign ? -a : a;
        abs_b = b_sign ? -b : b;
        
        // Perform subtraction based on sign cases
        if (a_sign == b_sign) begin
            // Same sign subtraction
            res = a - b;
        end else begin
            // Different signs - effectively addition
            if (abs_a > abs_b) begin
                res = abs_a - abs_b;
                res = a_sign ? -res : res;
            end else begin
                res = abs_b - abs_a;
                res = b_sign ? -res : res;
            end
        end
        
        // Handle zero case explicitly
        if (res == 0) begin
            c = 0;
        end else begin
            c = res;
        end
    end

endmodule