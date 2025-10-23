module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the sign of the inputs
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Same sign subtraction
    if (a_sign == b_sign) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // Compare the absolute values of the operands
        if (a[N-2:0] > b[N-2:0] || (a[N-2:0] == b[N-2:0] && a_sign == 0)) begin
            res = a + (~b + 1);  // Add the two's complement of b to a
        end else begin
            res = b + (~a + 1);  // Add the two's complement of a to b
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule