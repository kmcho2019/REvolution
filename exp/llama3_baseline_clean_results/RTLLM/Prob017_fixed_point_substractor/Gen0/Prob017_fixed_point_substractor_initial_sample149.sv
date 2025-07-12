module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First fixed-point input
    input [N-1:0] b,  // Second fixed-point input
    output [N-1:0] c  // Fixed-point output
);

reg [N-1:0] res;  // Internal register to store the result

// Perform subtraction based on the signs of the inputs
always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a[N-1] == 0 && b[N-1] == 1) begin  // a positive, b negative
            if (a > (b[N-1:0] == {N{1'b1}} ? -b : b)) begin  // a greater than b
                res = a + (~b + 1);  // Add absolute values, result is positive
            end else begin
                res = (~a + 1) + b;  // Add absolute values, result is negative
                res = ~res + 1;  // Two's complement to get the correct negative value
            end
        end else if (a[N-1] == 1 && b[N-1] == 0) begin  // a negative, b positive
            if ((a[N-1:0] == {N{1'b1}} ? -a : a) > b) begin  // a greater than b (considering absolute values)
                res = (~a + 1) + b;  // Add absolute values, result is negative
                res = ~res + 1;  // Two's complement to get the correct negative value
            end else begin
                res = a + (~b + 1);  // Add absolute values, result is positive
            end
        end
    end
    
    // Handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule