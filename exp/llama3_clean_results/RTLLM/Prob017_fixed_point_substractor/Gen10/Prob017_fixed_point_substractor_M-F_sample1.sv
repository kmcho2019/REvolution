module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(*) begin
    if (a >= 0 && b >= 0) begin // Both positive
        res = a - b;
    end else if (a < 0 && b < 0) begin // Both negative
        res = a - b;
    end else if (a >= 0 && b < 0) begin // a positive, b negative
        res = a + (-b); // Add absolute values
    end else begin // a negative, b positive
        res = a + (-b); // Add absolute values
    end
    
    if (res == 0) begin // Handle zero result
        c = 0;
    end else begin
        c = res;
    end
end

endmodule