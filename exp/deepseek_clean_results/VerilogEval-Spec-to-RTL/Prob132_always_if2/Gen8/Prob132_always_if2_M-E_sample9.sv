module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define states
    typedef enum logic {
        NORMAL,
        SHUTDOWN
    } state_t;

    state_t current_state;

    // State transition and output logic
    always @(*) begin
        case (current_state)
            NORMAL: begin
                shut_off_computer = 0;
                keep_driving = ~arrived & ~gas_tank_empty;
                if (cpu_overheated)
                    current_state = SHUTDOWN;
                else
                    current_state = NORMAL;
            end
            SHUTDOWN: begin
                shut_off_computer = 1;
                keep_driving = 0;  // Don't drive if computer is shut down
                current_state = SHUTDOWN;  // Latch in shutdown state
            end
        endcase
    end

    // Initial state (simulation only)
    initial begin
        current_state = NORMAL;
    end

endmodule