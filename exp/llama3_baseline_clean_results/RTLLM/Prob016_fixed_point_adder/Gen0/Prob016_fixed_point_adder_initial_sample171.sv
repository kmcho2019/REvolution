module fixed_point_adder #(parameter N = 32, parameter Q = 16) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign, perform absolute value addition
        if (a[N-1] == 1'b0) begin
            // Both positive
            res = a + b;
        end else begin
            // Both negative, subtract from zero to handle two's complement
            res = -(a + b);
        end
    end else begin
        // Different signs, perform absolute value subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a > -b) begin
                // a is larger, result is positive
                res = a + (~b + 1'b1);
            end else begin
                // b is larger, result is negative
                res = -(b + (~a + 1'b1));
            end
        end else begin
            // a is negative, b is positive
            if (-a > b) begin
                // a is larger, result is negative
                res = -(a + (~b + 1'b1));
            end else begin
                // b is larger, result is positive
                res = b + (~a + 1'b1);
            end
        end
    end
    
    // Ensure result does not overflow
    if (res[N-1] != res[N-2]) begin
        if (res[N-1] == 1'b0) begin
            // Positive overflow, saturate to max positive value
            res = {1'b0, {N-1{1'b1}}};
        end else begin
            // Negative overflow, saturate to max negative value
            res = {1'b1, {N-1{1'b0}}};
        end
    end
end

assign c = res;

endmodule