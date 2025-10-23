module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        res = a + (~b + 1'b1);  // Add absolute values
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a negative, b positive
        res = (~a + 1'b1) + b;  // Add absolute values
    end

    // Handle zero result
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 for zero result
    end
end

assign c = res;

endmodule