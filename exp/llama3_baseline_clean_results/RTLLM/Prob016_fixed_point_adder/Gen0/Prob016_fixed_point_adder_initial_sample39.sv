module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs are the same
        res = a + b;
    end else begin  // MSBs are different
        if (a[N-1] == 0) begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                if (a > (~b + 1)) begin  // a is larger
                    res = a - (~b + 1);
                    res[N-1] = 0;  // Set MSB to 0 (positive)
                end else begin  // b is larger
                    res = (~b + 1) - a;
                    if (res == 0) begin  // Result is zero
                        res[N-1] = 0;  // Set MSB to 0 (positive)
                    end else begin  // Result is negative
                        res[N-1] = 1;  // Set MSB to 1 (negative)
                    end
                end
            end
        end else begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                if ((~a + 1) > b) begin  // a is larger
                    res = (~a + 1) - b;
                    if (res == 0) begin  // Result is zero
                        res[N-1] = 0;  // Set MSB to 0 (positive)
                    end else begin  // Result is negative
                        res[N-1] = 1;  // Set MSB to 1 (negative)
                    end
                end else begin  // b is larger
                    res = b - (~a + 1);
                    res[N-1] = 0;  // Set MSB to 0 (positive)
                end
            end
        end
    end
end

assign c = res;

endmodule