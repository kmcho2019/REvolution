module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   logic [N-1:0] a,  // First N-bit fixed-point input operand
    input   logic [N-1:0] b,  // Second N-bit fixed-point input operand
    output  logic [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

logic [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always_comb begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1);  // Two's complement of b
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b;  // Two's complement of a
        end
    end

    // Handle zero result
    if (res == {N{1'b0}} || res == {N{1'b1}}) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 for zero result
    end
end

assign c = res;

endmodule