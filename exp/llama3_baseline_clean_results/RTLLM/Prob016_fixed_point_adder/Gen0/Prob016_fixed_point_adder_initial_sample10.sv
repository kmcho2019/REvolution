module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits (including integer and fractional parts)
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always_comb begin
    // Determine the sign of the operands
    reg sign_a, sign_b;
    sign_a = a[N-1];
    sign_b = b[N-1];

    // Perform absolute value addition or subtraction
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = (sign_a ? -a : a) + (sign_b ? -b : b);
    end else begin
        // Absolute value subtraction
        if ((sign_a ? -a : a) >= (sign_b ? -b : b)) begin
            res = (sign_a ? -a : a) - (sign_b ? -b : b);
        end else begin
            res = (sign_b ? -b : b) - (sign_a ? -a : a);
        end
    end

    // Set the MSB of the result according to the sign
    if (res < 0) begin
        res = ~res + 1;  // Two's complement representation
        c = {1'b1, res[N-2:0]};
    end else begin
        c = {1'b0, res[N-2:0]};
    end

    // Saturate the result to prevent overflow
    if (c[N-1] == 1'b1 && c[N-2] == 1'b1) begin
        c = {1'b1, {N-1{1'b1}}};
    end else if (c[N-1] == 1'b0 && c[N-2] == 1'b0) begin
        c = {N{1'b0}};
    end
end

endmodule