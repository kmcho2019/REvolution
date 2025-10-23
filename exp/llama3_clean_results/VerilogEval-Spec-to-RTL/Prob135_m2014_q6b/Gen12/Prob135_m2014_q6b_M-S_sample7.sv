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
        (w == 0)? ((y == STATE_A || y == STATE_B)? (y == STATE_A)? STATE_B : (y == STATE_B)? STATE_C : STATE_E :
                  (y == STATE_D)? STATE_F : STATE_C) :
        (w == 1)? ((y == STATE_A || y == STATE_B || y == STATE_D)? STATE_A : 
                  (y == STATE_C || y == STATE_E)? STATE_D : STATE_D);

    assign Y1 = next_state[1];

endmodule