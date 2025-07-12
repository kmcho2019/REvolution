module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= -b) begin
                res = a + (~b + 1);  // Add absolute values and determine sign
            end else begin
                res = -(~a + 1) + b;  // Result is negative
            end
        end else begin  // a is negative, b is positive
            if (-a >= b) begin
                res = -(~a + 1) + b;  // Add absolute values and determine sign
            end else begin
                res = a + (~b + 1);  // Result is positive
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;  // Ensure sign bit is 0 for zero result
    end
end

assign c = res;

endmodule