module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin  // a is positive, b is negative
        res = a + (~b + 1);  // Add the absolute value of b to a
    end else if (a[N-1] == 1 && b[N-1] == 0) begin  // a is negative, b is positive
        res = (~a + 1) + b;  // Add the absolute value of a to b
    end
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;  // Set sign bit to 0
    end
end

assign c = res;

endmodule