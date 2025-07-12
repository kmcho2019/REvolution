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
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= ~b + 1'b1) begin // a is greater than b
                res = a + ~b + 1'b1;
            end else begin
                res = ~b + 1'b1 - a;
            end
        end else begin // a is negative, b is positive
            if (~a + 1'b1 >= b) begin // a is greater than b (in magnitude)
                res = ~a + 1'b1 + ~b + 1'b1;
            end else begin
                res = b - (~a + 1'b1);
            end
        end
    end

    // Handle zero result explicitly
    if (res == 0) begin
        c[N-1] = 1'b0; // Ensure sign bit is 0 for zero result
        c[N-2:0] = {N-1{1'b0}};
    end else begin
        c = res;
    end
end

endmodule