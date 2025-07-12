module TopModule (
    input      clk,            // Added clock for state machine
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State machine definition
    typedef enum logic {IDLE, SHUTDOWN} state_t;
    state_t current_state, next_state;

    // Edge detection for arrived signal
    reg arrived_prev;
    wire arrived_fall = arrived_prev & ~arrived;
    wire arrived_rise = ~arrived_prev & arrived;

    // State machine transition logic
    always @(posedge clk) begin
        arrived_prev <= arrived;
        current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        shut_off_computer = 1'b0;
        
        case (current_state)
            IDLE: begin
                if (cpu_overheated) begin
                    next_state = SHUTDOWN;
                    shut_off_computer = 1'b1;
                end
            end
            SHUTDOWN: begin
                shut_off_computer = 1'b1;
                if (!cpu_overheated) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Driving logic with edge detection
    always @(posedge clk) begin
        if (arrived_fall) begin
            keep_driving <= 1'b0;
        end else if (arrived_rise) begin
            keep_driving <= ~gas_tank_empty;
        end
    end

endmodule