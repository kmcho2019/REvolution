module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow check
            res = (1 << N) - 1;  // Saturate at maximum value
        end
    end else begin  // Different signs
        if (a[N-1] == 1) begin  // a is negative
            if (b > -a) begin  // b is larger
                res = b + ~a + 1;  // Two's complement addition
                if (res[N-1] == 0) begin  // Result is positive
                    res = {1'b0, res[N-2:0]};  // Set MSB to 0
                end else begin  // Result is negative
                    res = {1'b1, res[N-2:0]};  // Set MSB to 1
                end
            end else begin  // a is larger
                res = ~b + a + 1;  // Two's complement addition
                res = {1'b1, res[N-2:0]};  // Set MSB to 1
            end
        end else begin  // b is negative
            if (a > -b) begin  // a is larger
                res = a + ~b + 1;  // Two's complement addition
                res = {1'b0, res[N-2:0]};  // Set MSB to 0
            end else begin  // b is larger
                res = ~a + b + 1;  // Two's complement addition
                if (res[N-1] == 0) begin  // Result is positive
                    res = {1'b0, res[N-2:0]};  // Set MSB to 0
                end else begin  // Result is negative
                    res = {1'b1, res[N-2:0]};  // Set MSB to 1
                end
            end
        end
    end
    c = res;
end

endmodule