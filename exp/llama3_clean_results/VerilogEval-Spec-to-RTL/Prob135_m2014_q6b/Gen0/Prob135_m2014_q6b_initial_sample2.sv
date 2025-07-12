module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next state logic for y[1]
    // Note that this code only implements the next-state logic for y[1]
    // and not the entire state machine.
    wire y1_next;
    assign y1_next = (y == 3'b100) | (y == 3'b101) | (y == 3'b110) | (y == 3'b111) | (y == 3'b001 & w);
endmodule