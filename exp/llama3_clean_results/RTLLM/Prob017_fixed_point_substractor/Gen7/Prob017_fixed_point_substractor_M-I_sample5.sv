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
    
    // Handle the case when the result is zero explicitly
    if (res == 0) begin
        c = 0; // Explicitly set the result to zero
    end else begin
        c = res; // Assign the computed result
    end
end

endmodule