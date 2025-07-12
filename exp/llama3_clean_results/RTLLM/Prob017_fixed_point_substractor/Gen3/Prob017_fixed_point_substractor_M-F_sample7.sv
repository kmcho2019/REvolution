module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

always @(a or b) begin
    // Directly compute the result of subtraction
    c = a - b;
    
    // Handle the edge case when the result is zero
    if (c == 0) begin
        c = 0; // Ensure the sign bit is set to 0
    end
end

endmodule