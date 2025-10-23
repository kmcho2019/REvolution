module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(a or b) begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1); // Add the two's complement of b to a
        end
        else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b; // Add the two's complement of a to b
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}}; // Set sign bit to 0
    end
    else begin
        c = res;
    end
end

endmodule