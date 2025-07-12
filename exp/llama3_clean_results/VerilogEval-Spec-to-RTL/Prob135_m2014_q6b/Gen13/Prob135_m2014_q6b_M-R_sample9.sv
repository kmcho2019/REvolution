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

    // Define the LUT for next state
    wire [2:0] lut_next_state [3'b111:3'b000][1:0];
    assign lut_next_state[STATE_A][0] = STATE_B;
    assign lut_next_state[STATE_A][1] = STATE_A;
    assign lut_next_state[STATE_B][0] = STATE_C;
    assign lut_next_state[STATE_B][1] = STATE_D;
    assign lut_next_state[STATE_C][0] = STATE_E;
    assign lut_next_state[STATE_C][1] = STATE_D;
    assign lut_next_state[STATE_D][0] = STATE_F;
    assign lut_next_state[STATE_D][1] = STATE_A;
    assign lut_next_state[STATE_E][0] = STATE_E;
    assign lut_next_state[STATE_E][1] = STATE_D;
    assign lut_next_state[STATE_F][0] = STATE_C;
    assign lut_next_state[STATE_F][1] = STATE_D;

    assign next_state = lut_next_state[y][~w];
    assign Y1 = next_state[1];

endmodule