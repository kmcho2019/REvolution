module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, perform addition
        res = a + b;
        if (res >= (1 << N)) begin // Overflow, handle it
            res = (1 << N) - 1; // Saturate at maximum value
        end
    end else begin // Different signs, perform subtraction
        if (a >= b) begin // a is greater
            res = a - b;
        end else begin // b is greater
            res = b - a;
        end
        if (res >= (1 << N)) begin // Overflow, handle it
            res = (1 << N) - 1; // Saturate at maximum value
        end
    end
    c = res;
end

endmodule