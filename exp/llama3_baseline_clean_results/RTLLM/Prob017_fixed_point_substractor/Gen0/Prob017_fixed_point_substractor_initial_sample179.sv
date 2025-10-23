module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
        if (a >= (~b + 1)) begin
            res = a + (~b + 1);
        end else begin
            res = (~a + 1) + b;
            res = ~res + 1; // Two's complement of the result
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a is negative, b is positive
        if ((~a + 1) >= b) begin
            res = (~a + 1) - b;
            res = ~res + 1; // Two's complement of the result
        end else begin
            res = (~b + 1) - (~a + 1);
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule