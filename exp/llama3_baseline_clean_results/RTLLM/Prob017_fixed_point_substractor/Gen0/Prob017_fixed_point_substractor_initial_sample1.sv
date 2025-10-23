module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        if (a > (1'b0 << (N-1)) + (~b + 1'b1)) begin
            res = a + (~b + 1'b1);
        end else begin
            res = (1'b1 << (N-1)) + ((~b + 1'b1) - a);
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a negative, b positive
        if ((1'b0 << (N-1)) + (~a + 1'b1) > b) begin
            res = (1'b0 << (N-1)) + ((~a + 1'b1) - b);
        end else begin
            res = (1'b1 << (N-1)) + (b - (~a + 1'b1));
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c[N-1] = 1'b0;
    end else begin
        c = res;
    end
end

endmodule