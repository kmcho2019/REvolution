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
    // Perform subtraction
    diff = A - B;
    
    // Decode the result to generate comparison outputs
    A_greater = (diff > 0)? 1'b1 : 1'b0;
    A_equal = (diff == 0)? 1'b1 : 1'b0;
    A_less = (diff < 0)? 1'b1 : 1'b0;
end

endmodule