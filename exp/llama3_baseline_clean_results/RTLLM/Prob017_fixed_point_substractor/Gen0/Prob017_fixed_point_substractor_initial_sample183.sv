module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different sign
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a positive, b negative
            if (a > (~b + 1'b1)) begin // a greater than b
                res = a + (~b + 1'b1); // Add absolute values, result positive
            end else begin
                res = (~a + 1'b1) + b; // Add absolute values, result negative
                res = ~res + 1'b1; // Two's complement
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a negative, b positive
            if ((~a + 1'b1) > b) begin // a greater than b (in absolute value)
                res = (~a + 1'b1) - b; // Subtract absolute values, result negative
                res = ~res + 1'b1; // Two's complement
            end else begin
                res = (~b + 1'b1) - a; // Subtract absolute values, result positive
            end
        end
    end
    
    // Handle zero result edge case
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule