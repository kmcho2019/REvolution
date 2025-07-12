module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] res;
    reg sign_a, sign_b;
    reg sign_res;

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];
        
        // Compute absolute values
        abs_a = sign_a ? -a : a;
        abs_b = sign_b ? -b : b;
        
        // Different sign case (a - b where b is negative or a is negative)
        if (sign_a ^ sign_b) begin
            res = abs_a + abs_b;
            sign_res = (abs_a > abs_b) ? sign_a : sign_b;
        end
        // Same sign case
        else begin
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                sign_res = sign_a;
            end
            else begin
                res = abs_b - abs_a;
                sign_res = ~sign_a;
            end
        end
        
        // Handle zero case explicitly
        if (res == 0) begin
            sign_res = 0;
        end
        
        // Combine sign and magnitude
        c = sign_res ? -res : res;
    end

endmodule