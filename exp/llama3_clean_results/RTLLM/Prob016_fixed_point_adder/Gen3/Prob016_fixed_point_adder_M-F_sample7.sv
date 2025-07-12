module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, perform addition
        res = a + b;
    end else begin // Different signs, perform subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    // Handle overflow
    if (res >= {1'b1, {N-1{1'b1}}}) begin // Positive overflow
        res = {1'b0, {N-1{1'b1}}};
    end else if (res < {N{1'b0}}) begin // Negative overflow
        res = {1'b1, {N-1{1'b0}}};
    end

    c = res;
end

endmodule