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
        STATE_BELOW_S0,      // No sensors active
        STATE_BETWEEN_S1_S0, // Only s[0] active
        STATE_BETWEEN_S2_S1, // s[0] and s[1] active
        STATE_ABOVE_S2       // All sensors active
    } state_t;

    state_t current_state, next_state, prev_state;

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
            STATE_BELOW_S0: begin
                if (s[0]) begin
                    next_state = STATE_BETWEEN_S1_S0;
                end else begin
                    next_state = STATE_BELOW_S0;
                end
            end
            STATE_BETWEEN_S1_S0: begin
                if (s[1]) begin
                    next_state = STATE_BETWEEN_S2_S1;
                end else if (!s[0]) begin
                    next_state = STATE_BELOW_S0;
                end else begin
                    next_state = STATE_BETWEEN_S1_S0;
                end
            end
            STATE_BETWEEN_S2_S1: begin
                if (s[2]) begin
                    next_state = STATE_ABOVE_S2;
                end else if (!s[1]) begin
                    next_state = STATE_BETWEEN_S1_S0;
                end else begin
                    next_state = STATE_BETWEEN_S2_S1;
                end
            end
            STATE_ABOVE_S2: begin
                if (!s[2]) begin
                    next_state = STATE_BETWEEN_S2_S1;
                end else begin
                    next_state = STATE_ABOVE_S2;
                end
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

    // Supplemental flow (dfr) is active when water level is rising
    assign dfr = ((prev_state < current_state) && 
                 (current_state != STATE_ABOVE_S2)) ? 1'b1 : 1'b0;

endmodule