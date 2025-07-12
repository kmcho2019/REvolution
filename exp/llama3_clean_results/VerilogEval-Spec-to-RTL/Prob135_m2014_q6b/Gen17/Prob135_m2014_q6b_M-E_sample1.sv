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

    reg [2:0] next_state;

    reg [2:0] next_state_table [6][2];

    initial begin
        // Initialize next state table for w = 0
        next_state_table[0][0] = STATE_B; // A, w = 0
        next_state_table[1][0] = STATE_C; // B, w = 0
        next_state_table[2][0] = STATE_E; // C, w = 0
        next_state_table[3][0] = STATE_F; // D, w = 0
        next_state_table[4][0] = STATE_E; // E, w = 0
        next_state_table[5][0] = STATE_C; // F, w = 0

        // Initialize next state table for w = 1
        next_state_table[0][1] = STATE_A; // A, w = 1
        next_state_table[1][1] = STATE_D; // B, w = 1
        next_state_table[2][1] = STATE_D; // C, w = 1
        next_state_table[3][1] = STATE_A; // D, w = 1
        next_state_table[4][1] = STATE_D; // E, w = 1
        next_state_table[5][1] = STATE_D; // F, w = 1
    end

    always @(y, w) begin
        case (y)
            STATE_A: next_state = (w == 1'b0)? next_state_table[0][0] : next_state_table[0][1];
            STATE_B: next_state = (w == 1'b0)? next_state_table[1][0] : next_state_table[1][1];
            STATE_C: next_state = (w == 1'b0)? next_state_table[2][0] : next_state_table[2][1];
            STATE_D: next_state = (w == 1'b0)? next_state_table[3][0] : next_state_table[3][1];
            STATE_E: next_state = (w == 1'b0)? next_state_table[4][0] : next_state_table[4][1];
            STATE_F: next_state = (w == 1'b0)? next_state_table[5][0] : next_state_table[5][1];
            default: next_state = STATE_A;
        endcase
        Y1 = next_state[1];
    end

endmodule