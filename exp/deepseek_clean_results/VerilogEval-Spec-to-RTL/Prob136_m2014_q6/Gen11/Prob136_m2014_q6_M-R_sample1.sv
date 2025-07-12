module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state definitions
    localparam [2:0] 
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b011,
        STATE_D = 3'b010,
        STATE_E = 3'b110,
        STATE_F = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            STATE_A: next_state = w ? STATE_A : STATE_B;
            STATE_B: next_state = w ? STATE_D : STATE_C;
            STATE_C: next_state = w ? STATE_D : STATE_E;
            STATE_D: next_state = w ? STATE_A : STATE_F;
            STATE_E: next_state = w ? STATE_D : STATE_E;
            STATE_F: next_state = w ? STATE_D : STATE_C;
            default: next_state = STATE_A; // Safe default
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Output logic - z is high when in states E or F
    assign z = current_state[2];

endmodule