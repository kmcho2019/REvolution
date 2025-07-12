module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        // Perform addition of absolute values
        res = a + b;
    end else begin
        // Determine which number has a larger absolute value
        if (a[N-1] == 1 && b[N-1] == 0) begin  // a is negative, b is positive
            if (a < b) begin
                res = b - (a[N-1]? -a : a);  // b is larger, subtract a from b
            end else begin
                res = (a[N-1]? -a : a) - b;  // a is larger, subtract b from a
            end
        end else begin  // a is positive, b is negative
            if (a < b) begin
                res = (b[N-1]? -b : b) - a;  // b is larger, subtract a from b
            end else begin
                res = a - (b[N-1]? -b : b);  // a is larger, subtract b from a
            end
        end
    end

    // Handle overflow
    if (res[N-1]!= a[N-1] && res[N-1]!= b[N-1]) begin
        // Overflow occurred, set result to max or min value
        if (res[N-1] == 1) begin
            res = {N{1'b1}};
        end else begin
            res = {N{1'b0}};
        end
    end
end

assign c = res;

endmodule