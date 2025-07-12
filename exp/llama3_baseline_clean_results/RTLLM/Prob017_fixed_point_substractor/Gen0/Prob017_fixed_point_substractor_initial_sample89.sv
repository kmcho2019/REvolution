module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,  // First input operand
    input   [N-1:0] b,  // Second input operand
    output  [N-1:0] c   // Output result
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 0 && b[N-1] == 1) begin // a is positive, b is negative
            if (a >= (~b + 1)) begin // a is greater than or equal to b
                res = a + (~b + 1);
            end else begin
                res = (~a + 1) + b;
            end
        end else if (a[N-1] == 1 && b[N-1] == 0) begin // a is negative, b is positive
            if ((~a + 1) >= b) begin // a is greater than or equal to b
                res = (~a + 1) + b;
            end else begin
                res = a + (~b + 1);
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule