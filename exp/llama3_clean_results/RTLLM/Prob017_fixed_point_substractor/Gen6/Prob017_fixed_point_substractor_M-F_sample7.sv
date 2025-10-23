module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c  // Declare output as reg for procedural assignment
);

always @(a or b) begin
    // Compute the result of subtraction directly and assign to c
    c = a - b;
end

endmodule