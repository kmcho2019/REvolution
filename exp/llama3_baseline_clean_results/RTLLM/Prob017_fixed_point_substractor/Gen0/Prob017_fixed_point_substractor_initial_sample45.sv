module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end else begin  // Different sign subtraction
        if (~a[N-1] && a >= ~b + 1'b1) begin  // a is positive, b is negative, and a >= -b
            res = a + ~b + 1'b1;
        end else if (~a[N-1] && a < ~b + 1'b1) begin  // a is positive, b is negative, and a < -b
            res = ~a + b + 1'b1;
        end else if (a[N-1] && ~b[N-1] && ~a + 1'b1 >= b) begin  // a is negative, b is positive, and -a >= b
            res = ~a + b + 1'b1;
        end else begin  // a is negative, b is positive, and -a < b
            res = a + ~b + 1'b1;
        end
    end

    // Handle zero result
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule