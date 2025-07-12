module TopModule (
    input      clk,              // System clock
    input      reset_n,          // Active-low reset
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Power Control FSM
    typedef enum logic {
        POWER_ON,
        POWER_OFF
    } power_state_t;

    power_state_t power_state, power_next;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            power_state <= POWER_ON;
        end else begin
            power_state <= power_next;
        end
    end

    always_comb begin
        power_next = power_state;
        shut_off_computer = 0;
        
        case (power_state)
            POWER_ON: begin
                if (cpu_overheated) begin
                    power_next = POWER_OFF;
                    shut_off_computer = 1;
                end
            end
            POWER_OFF: begin
                shut_off_computer = 1;
            end
        endcase
    end

    // Driving Control FSM
    typedef enum logic {
        DRIVING,
        STOPPED
    } driving_state_t;

    driving_state_t driving_state, driving_next;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            driving_state <= DRIVING;
        end else begin
            driving_state <= driving_next;
        end
    end

    always_comb begin
        driving_next = driving_state;
        keep_driving = 0;
        
        case (driving_state)
            DRIVING: begin
                if (arrived) begin
                    driving_next = STOPPED;
                end else begin
                    keep_driving = ~gas_tank_empty;
                end
            end
            STOPPED: begin
                if (~arrived) begin
                    driving_next = DRIVING;
                end
            end
        endcase
    end

endmodule