module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive
            if (a > (~b + 1)) begin // a is greater than b's two's complement
                res = a + (~b + 1);
            end else begin
                res = (~b + 1) - a;
                res = ~res + 1; // Invert and add 1 to get two's complement
            end
        end else begin // a is negative
            if (b > (~a + 1)) begin // b is greater than a's two's complement
                res = b + (~a + 1);
            end else begin
                res = (~a + 1) - b;
                res = ~res + 1; // Invert and add 1 to get two's complement
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0; // Explicitly set sign bit to 0 for zero result
    end

    c = res;
end

endmodule