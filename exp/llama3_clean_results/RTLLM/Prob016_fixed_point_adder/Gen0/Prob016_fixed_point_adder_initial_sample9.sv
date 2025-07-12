module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine the signs of the input operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Check if both operands have the same sign
    if (sign_a == sign_b) begin
        // Perform absolute value addition
        res = a + b;
        
        // Handle overflow
        if (res >= (1 << N)) begin
            res = (1 << N) - 1;
        end
        
        // Set the sign bit of the result
        if (sign_a) begin
            res[N-1] = 1'b1;
        end else begin
            res[N-1] = 1'b0;
        end
    end else begin
        // Perform absolute value subtraction
        reg [N:0] abs_a = {1'b0, a};
        reg [N:0] abs_b = {1'b0, b};
        
        if (abs_a > abs_b) begin
            // a is greater than b, result is a - b
            res = a - b;
            res[N-1] = 1'b0;  // Set the sign bit to 0 (positive)
        end else begin
            // b is greater than a, result is b - a
            res = b - a;
            if (res == 0) begin
                res[N-1] = 1'b0;  // Set the sign bit to 0 (positive) for zero result
            end else begin
                res[N-1] = 1'b1;  // Set the sign bit to 1 (negative)
            end
        end
        
        // Handle overflow
        if (res >= (1 << N)) begin
            res = (1 << N) - 1;
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule