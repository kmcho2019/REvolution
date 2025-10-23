module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define states for water levels
    typedef enum logic [1:0] {
        BELOW_S0,       // Below lowest sensor
        BETWEEN_S1_S0,  // Between s[1] and s[0]
        BETWEEN_S2_S1,  // Between s[2] and s[1]
        ABOVE_S2        // Above highest sensor
    } state_t;

    state_t current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW_S0;
            3'b001: next_state = BETWEEN_S1_S0;
            3'b011: next_state = BETWEEN_S2_S1;
            3'b111: next_state = ABOVE_S2;
            default: next_state = current_state; // Handle undefined sensor combinations
        endcase
    end

    // Output logic and state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Set flow rates based on current state
            case (current_state)
                BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                BETWEEN_S1_S0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                BETWEEN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase

            // Set supplemental flow (dfr) if water level is rising
            dfr <= (current_state > prev_state) && (current_state != ABOVE_S2);
        end
    end

endmodule