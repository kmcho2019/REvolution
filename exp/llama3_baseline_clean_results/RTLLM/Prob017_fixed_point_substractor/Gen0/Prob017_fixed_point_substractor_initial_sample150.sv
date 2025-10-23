module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register for storing the result

// Perform subtraction based on the signs of a and b
always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
            if (a < (~b + 1'b1)) begin  // If a < |b|
                res = (~b + 1'b1) - a;
                res[N-1] = 1'b1;  // Result is negative
            end else begin
                res = a - (~b + 1'b1);
                res[N-1] = 1'b0;  // Result is positive
            end
        end else begin  // a negative, b positive
            if ((~a + 1'b1) < b) begin  // If |a| < b
                res = b - (~a + 1'b1);
                res[N-1] = 1'b0;  // Result is positive
            end else begin
                res = (~a + 1'b1) - b;
                res[N-1] = 1'b1;  // Result is negative
            end
        end
    end
    // Handle the case when the result is zero
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;
    end
end

// Assign the result to the output
assign c = res;

endmodule