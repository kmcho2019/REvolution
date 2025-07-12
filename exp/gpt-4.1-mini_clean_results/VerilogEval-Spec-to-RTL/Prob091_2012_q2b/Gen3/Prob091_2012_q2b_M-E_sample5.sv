module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next state logic for Y1 (flip-flop input for y[1], state B)
// According to FSM: A --1--> B
// So Y1 = y[0] & w
assign Y1 = y[0] & w;

// Next state logic for Y3 (flip-flop input for y[3], state D)
// From FSM transitions:
// B(1:0) --0--> D(3)
// C(1:0) --0--> D(3)
// E(1:1) --0--> D(3)
// F(1:1) --0--> D(3)
//
// So Y3 = (~w) & (y[1] | y[2] | y[4] | y[5])
assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule