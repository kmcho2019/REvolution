module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, add absolute values
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = (1 << N) - 1;
        end
    end else begin  // Different signs, perform subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= ~b + 1) begin  // a is larger
                res = a - (~b + 1);
                if (res >= (1 << N)) begin  // Overflow handling
                    res = (1 << N) - 1;
                end
            end else begin  // b is larger
                res = (~b + 1) - a;
                if (res >= (1 << N)) begin  // Overflow handling
                    res = (1 << N) - 1;
                end
            end
        end else begin  // a is negative, b is positive
            if (~a + 1 >= b) begin  // a is larger
                res = (~a + 1) - b;
                if (res >= (1 << N)) begin  // Overflow handling
                    res = (1 << N) - 1;
                end
            end else begin  // b is larger
                res = b - (~a + 1);
                if (res >= (1 << N)) begin  // Overflow handling
                    res = (1 << N) - 1;
                end
            end
        end
    end
end

assign c = res;

endmodule