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
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        // Different sign subtraction
        if (a > -b) begin
            res = a + (~b + 1);  // Add absolute values
        end else begin
            res = (~a + 1) + b;  // Add absolute values and invert sign
            res = ~res + 1;  // Invert sign
        end
    end else begin  // a negative, b positive
        // Different sign subtraction
        if (-a > b) begin
            res = (~a + 1) + b;  // Add absolute values and invert sign
            res = ~res + 1;  // Invert sign
        end else begin
            res = a + (~b + 1);  // Add absolute values
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};  // Set sign bit to 0
    end else begin
        c = res;
    end
end

endmodule