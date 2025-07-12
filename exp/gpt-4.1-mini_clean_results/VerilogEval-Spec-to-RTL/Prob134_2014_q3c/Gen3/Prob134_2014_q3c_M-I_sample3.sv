module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Based on given transitions:
    // y = [y2 y1 y0]
    // next_state[2:0] = f(y,x)

    // From FSM table:

    // next_state[2] analysis:
    // For y=000, x=0 -> 0; x=1->0
    // y=001, x=0->0; x=1->1
    // y=010, x=0->0; x=1->0
    // y=011, x=0->0; x=1->0
    // y=100, x=0->0; x=1->1

    // So next_state[2] = 1 only when (y=001 && x=1) or (y=100 && x=1)
    // That is ( (y==3'b001) || (y==3'b100) ) & x

    wire y_eq_001 = (y == 3'b001);
    wire y_eq_100 = (y == 3'b100);

    wire next2 = ( (y_eq_001 || y_eq_100) & x );

    // next_state[1] analysis:
    // y=000: x=0->0, x=1->0
    // y=001: x=0->0, x=1->0
    // y=010: x=0->1, x=1->0
    // y=011: x=0->0, x=1->1
    // y=100: x=0->1, x=1->0

    // next_state[1] = 1 for (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    // so next_state[1] = (~x & ((y==010) || (y==100))) | (x & (y==011))

    wire y_eq_010 = (y == 3'b010);
    wire y_eq_011 = (y == 3'b011);

    wire next1 = (~x & (y_eq_010 || y_eq_100)) | (x & y_eq_011);

    // next_state[0] analysis:
    // y=000: x=0->0, x=1->1
    // y=001: x=0->1, x=1->0
    // y=010: x=0->0, x=1->1
    // y=011: x=0->1, x=1->0
    // y=100: x=0->1, x=1->0

    // next_state[0] = ( (~x & (y==001 || y==011 || y==100)) ) | ( x & (y==000 || y==010) )

    wire next0 = (~x & (y_eq_001 || y_eq_011 || y_eq_100)) | (x & (y_eq_000 || y_eq_010));

    wire y_eq_000 = (y == 3'b000);

    wire [2:0] next_state = {next2, next1, next0};

    assign z = (y == 3'b011) || (y == 3'b100);
    assign Y0 = next_state[0];

endmodule