module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] STATE_A = 6'b000001;
    parameter [5:0] STATE_B = 6'b000010;
    parameter [5:0] STATE_C = 6'b000100;
    parameter [5:0] STATE_D = 6'b001000;
    parameter [5:0] STATE_E = 6'b010000;
    parameter [5:0] STATE_F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            STATE_A: next_state = w ? STATE_B : STATE_A;
            STATE_B: next_state = w ? STATE_C : STATE_D;
            STATE_C: next_state = w ? STATE_E : STATE_D;
            STATE_D: next_state = w ? STATE_F : STATE_A;
            STATE_E: next_state = w ? STATE_E : STATE_D;
            STATE_F: next_state = w ? STATE_C : STATE_D;
            default: next_state = STATE_A;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    assign z = (current_state == STATE_E) | (current_state == STATE_F);

endmodule