module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin // Both positive
        res = a - b;
        if (res == 0) begin // Handle zero result
            res = {N{1'b0}};
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin // Both negative
        res = a - b;
        if (res == 0) begin // Handle zero result
            res = {N{1'b0}};
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
        if (a > (~b + 1)) begin
            res = a + (~b + 1);
        end else begin
            res = (~a + 1) + b;
            res = ~res + 1; // Two's complement for negative result
        end
        if (res == 0) begin // Handle zero result
            res = {N{1'b0}};
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a is negative, b is positive
        if ((~a + 1) > b) begin
            res = (~a + 1) + (~b + 1);
            res = ~res + 1; // Two's complement for negative result
        end else begin
            res = a + (~b + 1);
        end
        if (res == 0) begin // Handle zero result
            res = {N{1'b0}};
        end
    end
end

assign c = res;

endmodule