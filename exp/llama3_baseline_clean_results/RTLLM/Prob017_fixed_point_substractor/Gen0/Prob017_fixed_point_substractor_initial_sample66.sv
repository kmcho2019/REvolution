module fixed_point_subtractor #(
    parameter Q = 16, // number of fractional bits
    parameter N = 32  // total number of bits
) (
    input [N-1:0] a, // first input
    input [N-1:0] b, // second input
    output [N-1:0] c  // output
);

reg [N-1:0] res; // internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // same sign
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
        if (a >= (~b + 1)) begin // a is greater than or equal to b
            res = a + (~b + 1);
        end else begin
            res = (~b + 1) - a;
            res[N-1] = 1'b1; // set sign bit to 1 (negative)
        end
    end else begin // a is negative, b is positive
        if ((~a + 1) >= b) begin // a is less than or equal to b
            res = (~a + 1) + b;
            res[N-1] = 1'b1; // set sign bit to 1 (negative)
        end else begin
            res = b - (~a + 1);
        end
    end

    // handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule