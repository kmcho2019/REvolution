module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    wire stateA = (y == 3'b000);
    wire stateB = (y == 3'b001);
    wire stateC = (y == 3'b010);
    wire stateD = (y == 3'b011);
    wire stateE = (y == 3'b100);
    wire stateF = (y == 3'b101);

    // Next y[1] logic based on state and input w:
    // A: 0, B:1, C:w, D:0, E:w, F:1
    wire next_y1 = (stateB | stateF) 
                   | ( (stateC | stateE) & w );

    assign Y1 = y[1];

endmodule