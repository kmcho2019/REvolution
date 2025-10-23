module comparator_3bit (
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

wire signed [3:0] diff;
assign diff = {1'b0, A} - {1'b0, B};

assign {A_greater, A_equal, A_less} = (diff > 0) ? 3'b100 :
                                     (diff == 0) ? 3'b010 :
                                                   3'b001;

endmodule