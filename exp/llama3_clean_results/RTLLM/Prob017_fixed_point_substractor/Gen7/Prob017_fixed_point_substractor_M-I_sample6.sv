module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Always block to compute the result of subtraction
always @(*) begin
    // Compute the result of subtraction
    c = a - b;
    
    // Efficient handling of overflow and underflow
    if (c > (1 << (N-1)) - 1) begin
        // Handling overflow by wrapping around to the minimum value
        c = -(1 << (N-1));
    end else if (c < -(1 << (N-1))) begin
        // Handling underflow by wrapping around to the maximum value
        c = (1 << (N-1)) - 1;
    end else if (c == 0) begin
        // Ensure the sign bit is set to 0 when the result is zero
        c = 0;
    end
end

endmodule