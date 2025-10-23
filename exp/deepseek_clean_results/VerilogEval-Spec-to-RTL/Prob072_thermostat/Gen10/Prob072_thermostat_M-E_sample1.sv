module TopModule (
    input clk,          // Added clock for state machine
    input reset_n,      // Added reset for initialization
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        HEATING,
        COOLING
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (mode && too_cold) next_state = HEATING;
                else if (!mode && too_hot) next_state = COOLING;
                else next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) next_state = IDLE;
                else next_state = COOLING;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        heater = (current_state == HEATING);
        aircon = (current_state == COOLING);
        fan = fan_on || heater || aircon;
    end

endmodule