module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states
    typedef enum logic [1:0] {
        STATE_ABOVE_S2,
        STATE_BETWEEN_S2_S1,
        STATE_BETWEEN_S1_S0,
        STATE_BELOW_S0
    } state_t;

    // Current and next state registers
    state_t current_state, next_state;
    state_t prev_state; // To track previous state for dfr determination

    // State transition and output logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            STATE_ABOVE_S2: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BETWEEN_S2_S1;
                else if (s == 3'b001) next_state = STATE_BETWEEN_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BETWEEN_S2_S1: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BETWEEN_S2_S1;
                else if (s == 3'b001) next_state = STATE_BETWEEN_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BETWEEN_S1_S0: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BETWEEN_S2_S1;
                else if (s == 3'b001) next_state = STATE_BETWEEN_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BELOW_S0: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BETWEEN_S2_S1;
                else if (s == 3'b001) next_state = STATE_BETWEEN_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            default: next_state = STATE_BELOW_S0;
        endcase
    end

    // Output logic
    assign fr0 = (current_state == STATE_BETWEEN_S2_S1) || 
                 (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    assign fr1 = (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    assign fr2 = (current_state == STATE_BELOW_S0);
    assign dfr = (current_state != prev_state) && 
                 ((current_state == STATE_BETWEEN_S2_S1 && prev_state == STATE_BELOW_S0) ||
                  (current_state == STATE_BETWEEN_S1_S0 && prev_state == STATE_BETWEEN_S2_S1) ||
                  (current_state == STATE_BETWEEN_S1_S0 && prev_state == STATE_BELOW_S0) ||
                  (current_state == STATE_ABOVE_S2 && prev_state == STATE_BETWEEN_S2_S1) ||
                  (current_state == STATE_ABOVE_S2 && prev_state == STATE_BETWEEN_S1_S0) ||
                  (current_state == STATE_ABOVE_S2 && prev_state == STATE_BELOW_S0));

endmodule