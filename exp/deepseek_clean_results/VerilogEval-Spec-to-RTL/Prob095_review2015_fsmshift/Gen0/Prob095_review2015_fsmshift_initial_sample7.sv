module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states
    typedef enum logic {IDLE, ACTIVE} state_t;
    state_t current_state, next_state;

    // Counter for tracking active cycles
    reg [1:0] cycle_count;

    // State transition and counter logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= ACTIVE;
            cycle_count <= 2'b00;
        end else begin
            current_state <= next_state;
            if (current_state == ACTIVE) begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            ACTIVE: next_state = (cycle_count == 2'b11) ? IDLE : ACTIVE;
            IDLE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (current_state == ACTIVE);

endmodule