module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same signs
        if (a[N-1] == 1'b0) begin  // Both positive
            res = a + b;
        end else begin  // Both negative
            res = a + b;
        end
    end else begin  // Different signs
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            if (a >= (~b + 1'b1)) begin  // a is greater
                res = a - (~b + 1'b1);
            end else begin  // b is greater
                res = (~b + 1'b1) - a;
                res = ~res + 1'b1;  // Two's complement for negative result
            end
        end else begin  // a is negative, b is positive
            if ((~a + 1'b1) >= b) begin  // a is greater (in absolute value)
                res = (~a + 1'b1) - b;
                res = ~res + 1'b1;  // Two's complement for negative result
            end else begin  // b is greater
                res = b - (~a + 1'b1);
            end
        end
    end
end

assign c = res;

endmodule