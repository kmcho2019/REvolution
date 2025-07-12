module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    wire [2:0] next_state;

    assign next_state = 
        (y == STATE_A)? (w ? STATE_A : STATE_B) :
        (y == STATE_B)? (w ? STATE_D : STATE_C) :
        (y == STATE_C)? (w ? STATE_D : STATE_E) :
        (y == STATE_D)? (w ? STATE_A : STATE_F) :
        (y == STATE_E)? (w ? STATE_D : STATE_E) :
        (y == STATE_F)? (w ? STATE_D : STATE_C) :
        STATE_A;

    assign Y1 = next_state[1];

endmodule