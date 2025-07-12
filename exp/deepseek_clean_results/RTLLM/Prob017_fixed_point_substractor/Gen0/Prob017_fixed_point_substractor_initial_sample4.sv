module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg [N-1:0] abs_a, abs_b;
    reg sign_a, sign_b;
    reg [N-1:0] res;

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];
        
        // Compute absolute values
        abs_a = sign_a ? -a : a;
        abs_b = sign_b ? -b : b;
        
        // Perform subtraction based on sign cases
        if (sign_a == sign_b) begin
            // Same sign subtraction
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                res[N-1] = sign_a;  // Keep original sign
            end else begin
                res = abs_b - abs_a;
                res[N-1] = ~sign_a;  // Flip sign
            end
        end else begin
            // Different signs - effectively addition
            res = abs_a + abs_b;
            res[N-1] = sign_a;  // Result takes sign of first operand
        end
        
        // Handle zero case explicitly
        if (res[N-2:0] == 0) begin
            res[N-1] = 1'b0;
        end
        
        c = res;
    end

endmodule