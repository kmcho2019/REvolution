module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional)
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a + (~b + 1);
        end else begin // a is negative, b is positive
            res = (~a + 1) + b;
        end
    end

    // Handle zero result explicitly
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule