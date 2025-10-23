module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow
);

    reg [N-2:0] mag_a, mag_b, mag_res;
    reg sign_a, sign_b, sign_res;
    reg [N-1:0] abs_a, abs_b;
    wire [N-1:0] sum, diff;

    always @(*) begin
        // Extract signs and magnitudes
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a = sign_a ? -a[N-2:0] : a[N-2:0];
        mag_b = sign_b ? -b[N-2:0] : b[N-2:0];
        
        // Calculate absolute values
        abs_a = {1'b0, mag_a};
        abs_b = {1'b0, mag_b};
        
        // Perform addition or subtraction based on signs
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            {overflow, mag_res} = abs_a + abs_b;
            sign_res = sign_a;
        end
        else begin
            // Different signs: subtract smaller from larger
            if (abs_a >= abs_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;
                overflow = 1'b0;
            end
            else begin
                mag_res = abs_b - abs_a;
                sign_res = sign_b;
                overflow = 1'b0;
            end
        end
        
        // Handle zero case (positive zero)
        if (mag_res == 0)
            sign_res = 1'b0;
            
        // Check for overflow in magnitude
        if (mag_res[N-2] && !overflow)  // Magnitude exceeds positive range
            overflow = 1'b1;
            
        // Form final result
        c = {sign_res, mag_res[N-2:0]};
    end

endmodule