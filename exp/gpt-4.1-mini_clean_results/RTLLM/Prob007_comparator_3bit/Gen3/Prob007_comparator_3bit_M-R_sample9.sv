module comparator_3bit (
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

wire [3:0] diff; // 4 bits to accommodate subtraction borrow

assign diff = {1'b0, A} - {1'b0, B};

assign A_equal   = (diff == 4'b0000);
assign A_greater = (~diff[3]) & (~A_equal); // diff[3] is the sign bit in 2's complement subtraction; 0 means A >= B
assign A_less    = diff[3];                  // sign bit set means A < B

endmodule