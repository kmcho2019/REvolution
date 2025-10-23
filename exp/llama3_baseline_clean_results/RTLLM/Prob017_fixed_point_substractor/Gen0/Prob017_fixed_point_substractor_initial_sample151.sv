module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of 'a' and 'b'
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b1;  // Set the sign bit
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // 'a' positive, 'b' negative
        res = a + (~b + 1'b1);  // Two's complement of 'b'
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // 'a' negative, 'b' positive
        res = (~a + 1'b1) + b;  // Two's complement of 'a'
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Explicitly set sign bit to 0
    end
end

assign c = res;

endmodule