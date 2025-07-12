module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a, b) begin
    // Sign handling stage
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Same sign subtraction
        if (a[N-1] == 1'b0) begin
            // Both positive
            res = a - b;
        end else begin
            // Both negative
            res = a - b;
        end
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            res = a + (~b + 1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1) + b;
        end
    end
    
    // Zero detection logic
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule