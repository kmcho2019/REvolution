module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res; // Internal register to store the result

always @(a or b) begin
    // Directly compute the result of subtraction
    res = a - b;
    
    // Handle the edge case when the result is zero
    if (res == 0) begin
        res = 0; // Ensure the sign bit is set to 0
    end
    
    // Assign the internal register to the output port
    c = res;
end

endmodule