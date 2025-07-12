module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a, b) begin
    // Check if the most significant bits (MSBs) of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // If the result overflows, adjust it to fit within the N-bit range
        if (res >= (1 << N)) begin
            res = res - (1 << N);
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a >= ~b + 1) begin
                // a is greater than b, result is a - b and is positive
                res = a + (~b + 1);
            end else begin
                // b is greater than a, result is b - a
                res = (~a + 1) + b;
                // Set the MSB of the result to 1 (negative) if the result is not zero
                if (res != 0) begin
                    res[N-1] = 1;
                end
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1 >= b) begin
                // a is greater than b, result is a - b and is negative
                res = (~a + 1) + (~b + 1);
                // Set the MSB of the result to 1 (negative)
                res[N-1] = 1;
            end else begin
                // b is greater than a, result is b - a and is positive
                res = b + (~a + 1);
            end
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule