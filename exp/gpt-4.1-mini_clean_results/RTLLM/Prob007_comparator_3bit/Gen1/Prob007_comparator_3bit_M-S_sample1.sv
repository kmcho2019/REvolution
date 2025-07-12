module comparator_3bit (
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

assign {A_greater, A_equal, A_less} = (A > B) ? 3'b100 :
                                     (A == B) ? 3'b010 :
                                     3'b001;

endmodule