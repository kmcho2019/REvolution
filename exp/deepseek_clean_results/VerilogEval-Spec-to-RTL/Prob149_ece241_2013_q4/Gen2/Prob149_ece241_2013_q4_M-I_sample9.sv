module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states corresponding to water levels
    typedef enum logic [1:0] {
        BELOW_S0,       // No sensors (000)
        BETWEEN_S1_S0,  // Only s[0] (001)
        BETWEEN_S2_S1,  // s[1:0] (011)
        ABOVE_S2        // All sensors (111)
    } state_t;

    state_t current_state, next_state;
    state_t prev_state;

    // State transition logic with exact pattern matching
    always_comb begin
        case (s)
            3'b000: next_state = BELOW_S0;
            3'b001: next_state = BETWEEN_S1_S0;
            3'b011: next_state = BETWEEN_S2_S1;
            3'b111: next_state = ABOVE_S2;
            default: next_state = current_state; // Hold current state for invalid patterns
        endcase
    end

    // State register and previous state tracking
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output logic - strictly follows specification
    assign fr0 = (reset) ? 1'b1 : 
                (current_state == BELOW_S0 || 
                 current_state == BETWEEN_S1_S0 || 
                 current_state == BETWEEN_S2_S1);

    assign fr1 = (reset) ? 1'b1 : 
                (current_state == BELOW_S0 || 
                 current_state == BETWEEN_S1_S0);

    assign fr2 = (reset) ? 1'b1 : 
                (current_state == BELOW_S0);

    // dfr is asserted when moving to a higher state
    assign dfr = (reset) ? 1'b1 :
                ((current_state == BETWEEN_S1_S0 && prev_state == BELOW_S0) ||
                 (current_state == BETWEEN_S2_S1 && prev_state == BETWEEN_S1_S0) ||
                 (current_state == ABOVE_S2 && prev_state == BETWEEN_S2_S1));

endmodule