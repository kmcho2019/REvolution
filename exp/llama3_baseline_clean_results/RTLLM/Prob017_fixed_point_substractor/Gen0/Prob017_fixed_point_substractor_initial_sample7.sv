module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Same sign subtraction
    if (a[N-1] == b[N-1]) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // a is positive, b is negative
        if (a[N-1] == 0 && b[N-1] == 1) begin
            if (a > (~b + 1)) begin
                res = a + (~b + 1);
            end
            else begin
                res = (~b + 1) - a;
            end
        end
        // a is negative, b is positive
        else begin
            if (b > (~a + 1)) begin
                res = b + (~a + 1);
            end
            else begin
                res = (~a + 1) - b;
            end
        end
    end
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end
    else begin
        c = res;
    end
end

endmodule