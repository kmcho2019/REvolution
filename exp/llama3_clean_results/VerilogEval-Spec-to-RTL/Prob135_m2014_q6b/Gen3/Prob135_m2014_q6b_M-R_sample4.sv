module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    wire next_y1;
    assign next_y1 = (w)? (
        (y == 3'b000)? y[1] :
        (y == 3'b001)? y[1] :
        (y == 3'b010)? 1 :
        (y == 3'b011)? 0 :
        (y == 3'b100)? 0 :
        (y == 3'b101)? 0 :
        y[1]
    ) : (
        (y == 3'b000)? 1 :
        (y == 3'b001)? 1 :
        (y == 3'b010)? 1 :
        (y == 3'b011)? 0 :
        (y == 3'b100)? 0 :
        (y == 3'b101)? 0 :
        y[1]
    );
endmodule