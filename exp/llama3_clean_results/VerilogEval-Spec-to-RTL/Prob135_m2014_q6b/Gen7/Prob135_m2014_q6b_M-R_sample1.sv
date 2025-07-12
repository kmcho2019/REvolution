module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = (y[2:0] == 3'b001) ? ~w :  // State B
            (y[2:0] == 3'b010) ? 1'b1 :  // State C
            (y[2:0] == 3'b011) ? ~w :  // State D
            (y[2:0] == 3'b100) ? 1'b1 :  // State E
            (y[2:0] == 3'b101) ? 1'b1;  // State F

endmodule