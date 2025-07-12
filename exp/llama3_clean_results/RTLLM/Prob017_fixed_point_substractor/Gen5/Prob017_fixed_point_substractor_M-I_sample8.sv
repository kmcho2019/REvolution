module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

// Internal register to store the result
reg signed [N-1:0] res;

// Always block to compute the result of subtraction
always @(a or b) begin
    // Compute the result of subtraction
    res = a - b;
    
    // Handle edge cases
    if (res == 0) begin
        // Ensure the sign bit is set to 0 when the result is zero
        res = 0;
    end else if (res > (1 << (N - 1)) - 1) begin
        // Handle overflow
        res = (1 << (N - 1)) - 1;
    end else if (res < -(1 << (N - 1))) begin
        // Handle underflow
        res = -(1 << (N - 1));
    end
    
    // Assign the internal register to the output port
    c = res;
end

endmodule