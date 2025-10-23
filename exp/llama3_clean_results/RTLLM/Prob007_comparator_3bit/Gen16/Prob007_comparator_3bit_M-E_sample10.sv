module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] diff;

always @(*)
begin
    // Calculate the difference between A and B
    diff = A - B;
    
    // Determine the comparison result based on the difference
    A_greater = (diff[2] == 0 && diff != 3'b000) ? 1'b1 : 1'b0;
    A_equal = (diff == 3'b000) ? 1'b1 : 1'b0;
    A_less = (diff[2] == 1) ? 1'b1 : 1'b0;
end

endmodule