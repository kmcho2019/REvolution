module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c  // Declare output as reg for procedural assignment
);

reg signed [N-1:0] res; // Internal register to store the result

always @(a or b) begin
    // Compute the result of subtraction directly
    res = a - b;
    
    // Simplify the logic by removing the conditional statement for zero
    // Since 'res' will inherently be zero when a equals b, no explicit check is needed
    c = res; 
end

endmodule