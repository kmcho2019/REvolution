module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Perform subtraction based on signs
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin
        // a is positive, b is negative
        if (a >= ~b + 1) begin
            res = a + ~b + 1;
        end else begin
            res = ~(~a + b);
        end
    end else begin
        // a is negative, b is positive
        if (~a + 1 >= b) begin
            res = ~a + 1 + b;
        end else begin
            res = ~(a + ~b + 1);
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;
    end
end

assign c = res;

endmodule