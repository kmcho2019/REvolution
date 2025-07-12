module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);
    // State encoding: A=000, B=001, C=010, D=011, E=100, F=101
    wire isA = (y == 3'b000);
    wire isB = (y == 3'b001);
    wire isC = (y == 3'b010);
    wire isD = (y == 3'b011);
    wire isE = (y == 3'b100);
    wire isF = (y == 3'b101);

    // According to the FSM transition table and required next y1 bit:
    // next y1=1 when:
    // - from B (state B) with any w
    // - from C with w=1
    // - from E with w=1
    // - from F with any w
    wire y1_next =
        (isB) |
        (isC & w) |
        (isE & w) |
        (isF);

    assign Y1 = y1_next;

endmodule