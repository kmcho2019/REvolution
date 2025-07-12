module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    // Next-state logic for y[1] using a case statement
    assign Y1 = (y == 3'b000 || y == 3'b001) ? ~w :
                (y == 3'b010) ? w :
                (y == 3'b011 || y == 3'b100) ? w :
                (y == 3'b101) ? ~w : 1'b0;
endmodule