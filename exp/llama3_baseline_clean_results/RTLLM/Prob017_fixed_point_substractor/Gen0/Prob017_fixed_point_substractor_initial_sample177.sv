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
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= -b) begin
                res = a + (~b + 1);  // Two's complement of b
            end else begin
                res = (~a + 1) + b;  // Two's complement of a
            end
        end else begin  // a is negative, b is positive
            if (-a >= b) begin
                res = (~a + 1) + b;  // Two's complement of a
            end else begin
                res = a + (~b + 1);  // Two's complement of b
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};  // Set sign bit to 0 for zero result
    end else begin
        c = res;
    end
end

endmodule