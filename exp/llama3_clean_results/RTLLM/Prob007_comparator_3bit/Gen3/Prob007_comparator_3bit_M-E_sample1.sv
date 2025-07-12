module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] diff;

always @(*) begin
    // Perform subtraction and analyze the sign bit
    diff = A - B;
    
    // Determine the outputs based on the sign of the difference
    A_greater = (diff[2] == 0 && diff!= 3'b000);
    A_equal = (diff == 3'b000);
    A_less = (diff[2] == 1);
end

endmodule