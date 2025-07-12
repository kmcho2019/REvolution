module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer and fractional)
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        // Subtract b from a
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        // Subtract b from a
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        // Add a and b (since b is negative, its absolute value is subtracted from a)
        res = a + (~b + 1'b1);  // Two's complement of b
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a negative, b positive
        // Add a and b (since a is negative, its absolute value is added to b)
        res = (~a + 1'b1) + b;  // Two's complement of a
    end

    // Handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule