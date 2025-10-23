module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine if the signs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > ~b + 1) begin
                // a is greater than b
                res = a - (~b + 1);
            end else begin
                // b is greater than a
                res = (~a + 1) - b;
                // Set MSB to 1 if result is negative
                if (res[N-1] == 0) begin
                    res[N-1] = 1;
                end
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1 > b) begin
                // a is greater than b
                res = (~a + 1) - b;
            end else begin
                // b is greater than a
                res = b - (~a + 1);
            end
        end
    end
    // Assign result to output
    c = res;
end

endmodule