module fixed_point_adder #
(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

// Determine the operation based on the signs of a and b
always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, addition
        res = a + b;
    end else begin  // Different signs, subtraction
        if (a >= b) begin
            res = a - b;
            if (res == 0) begin  // Set MSB to 0 if result is zero
                res[N-1] = 0;
            end
        end else begin
            res = b - a;
            if (res != 0) begin  // Set MSB to 1 if result is negative
                res[N-1] = 1;
            end else begin  // Set MSB to 0 if result is zero
                res[N-1] = 0;
            end
        end
    end
    // Manage overflow by keeping the MSB consistent with the operation result
    if (res[N] == 1) begin  // Overflow detected
        if (a[N-1] == 0) begin  // Positive overflow
            res = {1'b1, {N-1{1'b1}}};
        end else begin  // Negative overflow
            res = {1'b1, {N-1{1'b0}}};
        end
    end
end

// Assign the result to output port c
assign c = res;

endmodule