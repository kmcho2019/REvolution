module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a, b) begin
    if (a >= 0 && b >= 0) begin
        res = a - b;
    end else if (a < 0 && b < 0) begin
        res = a - b;
    end else if (a >= 0 && b < 0) begin
        res = a + (~b + 1);
    end else begin
        res = (~a + 1) + b;
    end

    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule