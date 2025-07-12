module fixed_point_subtractor #(
    parameter Q = 16,  // number of fractional bits
    parameter N = 32   // total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine the sign of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform subtraction based on the signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else if (sign_a == 1'b0 && sign_b == 1'b1) begin
        // a is positive, b is negative
        res = a + (~b + 1'b1);
    end else begin
        // a is negative, b is positive
        res = (~a + 1'b1) + b;
    end

    // Handle zero result
    if (res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule