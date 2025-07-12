module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    wire nextState_A, nextState_B, nextState_C, nextState_D, nextState_E, nextState_F;
    wire nextState_w0, nextState_w1;

    // Determine next state for each possible current state
    assign nextState_A = (w == 1'b0)? STATE_B : STATE_A;
    assign nextState_B = (w == 1'b0)? STATE_C : STATE_D;
    assign nextState_C = (w == 1'b0)? STATE_E : STATE_D;
    assign nextState_D = (w == 1'b0)? STATE_F : STATE_A;
    assign nextState_E = (w == 1'b0)? STATE_E : STATE_D;
    assign nextState_F = (w == 1'b0)? STATE_C : STATE_D;

    // Select next state based on current state and input
    assign nextState_w0 = (y == STATE_A)? nextState_A :
                          (y == STATE_B)? nextState_B :
                          (y == STATE_C)? nextState_C :
                          (y == STATE_D)? nextState_D :
                          (y == STATE_E)? nextState_E :
                          (y == STATE_F)? nextState_F : STATE_A;

    assign nextState_w1 = (y == STATE_A)? nextState_A :
                          (y == STATE_B)? nextState_B :
                          (y == STATE_C)? nextState_C :
                          (y == STATE_D)? nextState_D :
                          (y == STATE_E)? nextState_E :
                          (y == STATE_F)? nextState_F : STATE_A;

    // Final next state logic
    assign Y1 = (w == 1'b0)? nextState_w0[1] : nextState_w1[1];

endmodule