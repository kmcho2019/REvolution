module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine if both numbers have the same sign
    if (a[N-1] == b[N-1]) begin
        // Perform absolute value addition
        res = a + b;
        
        // If there's an overflow, handle it
        if (res[N] == 1'b1) begin
            // If the result overflows, we only care about the sign bit for the final output
            // The actual overflow value will be truncated to fit within N bits
            c = {a[N-1], {N-1{1'b0}}};
        end else begin
            c = res;
        end
    end else begin
        // Perform absolute value subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a >= (~b + 1'b1)) begin
                res = a - (~b + 1'b1);
                c = res;
            end else begin
                res = (~b + 1'b1) - a;
                c = {1'b1, {N-1{1'b0}}} + res;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1'b1) >= b) begin
                res = (~a + 1'b1) - b;
                c = {1'b1, {N-1{1'b0}}} + res;
            end else begin
                res = b - (~a + 1'b1);
                c = res;
            end
        end
    end
end

endmodule