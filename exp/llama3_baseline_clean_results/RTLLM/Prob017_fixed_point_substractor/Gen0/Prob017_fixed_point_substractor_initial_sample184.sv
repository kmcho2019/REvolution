module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both a and b are positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = {1'b1, {N-1{1'b0}}} - (b - a);
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both a and b are negative
        if (a <= b) begin
            res = a - b;
        end else begin
            res = {1'b1, {N-1{1'b0}}} - (a - b);
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        res = a + (~b + 1'b1);  // Two's complement addition
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
        res = (~a + 1'b1) + b;  // Two's complement addition
    end

    // Handle zero result case
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Explicitly set sign bit to 0
    end
end

assign c = res;

endmodule