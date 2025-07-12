module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    wire next_y1;
    assign next_y1 = (
        (y == 3'b000 && ~w)? 1 :
        (y == 3'b001 && ~w)? 1 :
        (y == 3'b011 && ~w)? 0 :
        (y == 3'b101 && ~w)? 0 :
        (y == 3'b100 && ~w)? 0 :
        (y == 3'b101 && w)? 0 :
        y[1]
    );

    // Alternatively, using a case statement
    wire next_y1_case;
    assign next_y1_case = (
        (y == 3'b000)? (w? 0 : 1) :
        (y == 3'b001)? (w? 1 : 1) :
        (y == 3'b011)? (w? 0 : 0) :
        (y == 3'b100)? (w? 1 : 0) :
        (y == 3'b101)? (w? 1 : 0) :
        (y == 3'b010 || y == 3'b011 || y == 3'b100 || y == 3'b101)? y[1] :
        0
    );
endmodule