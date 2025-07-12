module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Check if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign, check which one is positive
        if (a[N-1] == 0) begin  // a is positive
            // If a is greater than b, result is positive; otherwise, negative
            if (a >= (b ^ {N{1'b1}} + 1'b1)) begin
                res = a + (~b + 1'b1);
            end else begin
                res = (~a + 1'b1) + b;
                // Since the result is negative, we need to invert the bits and add 1
                res = ~res + 1'b1;
            end
        end else begin  // a is negative
            // If b is greater than a, result is positive; otherwise, negative
            if (b >= (a ^ {N{1'b1}} + 1'b1)) begin
                res = b + (~a + 1'b1);
            end else begin
                res = (~b + 1'b1) + a;
                // Since the result is negative, we need to invert the bits and add 1
                res = ~res + 1'b1;
            end
        end
    end
    
    // Handle zero result to ensure sign bit is 0
    if (res == 0) begin
        res = {N{1'b0}};
    end
    
    // Assign the result to the output
    c = res;
end

endmodule