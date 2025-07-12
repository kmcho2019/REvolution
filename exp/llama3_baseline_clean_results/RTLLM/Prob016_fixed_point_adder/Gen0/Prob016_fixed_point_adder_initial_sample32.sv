module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, absolute value addition
        res = a + b;
    end else begin  // Different signs, absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (a < b) begin  // |b| > |a|
                res = b - a;
            end else begin  // |a| >= |b|
                res = a - b;
                res[N-1] = 1;  // Set MSB to 1 (negative)
            end
        end else begin  // b is negative
            if (b < a) begin  // |a| > |b|
                res = a - b;
            end else begin  // |b| >= |a|
                res = b - a;
                res[N-1] = 1;  // Set MSB to 1 (negative)
            end
        end
    end

    // Check for overflow and adjust MSB if necessary
    if (res[N-1]!= res[N-2]) begin
        res[N-1] = res[N-2];  // Adjust MSB to match the sign of the result
    end

    c = res;
end

endmodule