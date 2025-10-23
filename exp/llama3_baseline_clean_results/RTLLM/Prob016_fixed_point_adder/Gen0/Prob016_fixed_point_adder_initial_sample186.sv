module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, perform addition
        res = a + b;
    end else begin  // Different signs, perform subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    // Handle overflow
    if (res >= 2**(N-1)) begin
        res = 2**(N-1) - 1;
    end else if (res < -2**(N-1)) begin
        res = -2**(N-1);
    end
end

assign c = res;

endmodule