module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Both have the same sign
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = (1 << N) - 1;  // Set to maximum value for N bits
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin  // a is positive
            if (a >= b) begin
                res = a - b;
                res[N-1] = 0;  // Set MSB to 0 (positive result)
            end else begin
                res = b - a;
                if (res == 0) begin
                    res[N-1] = 0;  // Set MSB to 0 (zero result)
                end else begin
                    res[N-1] = 1;  // Set MSB to 1 (negative result)
                end
            end
        end else begin  // a is negative
            if (a >= b) begin
                res = a - b;
                if (res == 0) begin
                    res[N-1] = 0;  // Set MSB to 0 (zero result)
                end else begin
                    res[N-1] = 1;  // Set MSB to 1 (negative result)
                end
            end else begin
                res = b - a;
                res[N-1] = 0;  // Set MSB to 0 (positive result)
            end
        end
    end
end

assign c = res;

endmodule