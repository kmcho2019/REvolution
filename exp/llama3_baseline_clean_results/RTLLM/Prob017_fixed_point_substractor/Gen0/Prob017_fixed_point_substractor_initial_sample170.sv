module fixed_point_subtractor #(
    parameter Q = 8,  // number of fractional bits
    parameter N = 16  // total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Check the signs of the input operands
    if (a[N-1] == b[N-1]) begin  // same sign
        // Subtract the two numbers
        if (a[N-1] == 1) begin  // both negative
            res = ~a + 1 - (~b + 1);
        end else begin  // both positive
            res = a - b;
        end
    end else begin  // different signs
        // Add the absolute values of the two numbers
        if (a[N-1] == 1) begin  // a is negative, b is positive
            if (~a + 1 > b) begin
                res = ~a + 1 - b;
            end else begin
                res = b - (~a + 1);
                res[N-1] = 1;  // set the sign bit to 1
            end
        end else begin  // a is positive, b is negative
            if (a > ~b + 1) begin
                res = a - (~b + 1);
            end else begin
                res = ~b + 1 - a;
                res[N-1] = 1;  // set the sign bit to 1
            end
        end
    end
    
    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 0;
    end
end

assign c = res;

endmodule