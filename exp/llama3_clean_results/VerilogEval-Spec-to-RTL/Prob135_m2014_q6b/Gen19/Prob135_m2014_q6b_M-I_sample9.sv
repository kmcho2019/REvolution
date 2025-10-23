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

    wire next_state_A, next_state_B, next_state_C, next_state_D, next_state_E, next_state_F;

    assign next_state_A = (y == STATE_D && ~w);
    assign next_state_B = (y == STATE_A && ~w);
    assign next_state_C = (y == STATE_B && ~w) || (y == STATE_F && ~w);
    assign next_state_D = (y == STATE_B && w) || (y == STATE_C && w) || (y == STATE_E && w) || (y == STATE_F && w);
    assign next_state_E = (y == STATE_C && ~w) && w;
    assign next_state_F = (y == STATE_D && ~w);

    wire [2:0] next_state;
    assign next_state = 
        (next_state_A)? STATE_A :
        (next_state_B)? STATE_B :
        (next_state_C)? STATE_C :
        (next_state_D)? STATE_D :
        (next_state_E)? STATE_E :
        (next_state_F)? STATE_F :
        STATE_A;

    assign Y1 = next_state[1];

endmodule