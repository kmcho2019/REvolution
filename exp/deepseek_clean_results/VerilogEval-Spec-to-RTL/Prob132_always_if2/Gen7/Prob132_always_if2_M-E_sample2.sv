module TopModule (
    input clk,                // Clock for state machine
    input reset,              // Asynchronous reset
    input cpu_overheated,     // Signal when CPU temperature exceeds threshold
    output reg shut_off_computer, // Control signal to power off computer
    input arrived,            // Flag indicating destination reached
    input gas_tank_empty,     // Signal when vehicle fuel is depleted
    output reg keep_driving   // Control signal to continue driving
);

    // Define states
    typedef enum logic {
        NORMAL,
        EMERGENCY
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= NORMAL;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            NORMAL: if (cpu_overheated) next_state = EMERGENCY;
            EMERGENCY: next_state = EMERGENCY; // Stay in emergency until reset
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        case (current_state)
            NORMAL: begin
                shut_off_computer <= 1'b0;
                keep_driving <= ~arrived & ~gas_tank_empty;
            end
            EMERGENCY: begin
                shut_off_computer <= 1'b1;
                keep_driving <= 1'b0;  // Stop driving in emergency
            end
        endcase
    end

endmodule