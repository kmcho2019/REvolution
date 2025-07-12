module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: Normal, 1: Shutdown

    always @(*) begin
        case (state)
            0: begin // Normal State
                shut_off_computer = 0;
                keep_driving = ~arrived & ~gas_tank_empty;
                if (cpu_overheated)
                    state = 1; // Transition to Shutdown State
            end
            1: begin // Shutdown State
                shut_off_computer = 1;
                keep_driving = 0; // Driving condition not monitored in Shutdown State
                if (~cpu_overheated)
                    state = 0; // Transition back to Normal State
            end
            default: begin
                state = 0; // Default to Normal State
                shut_off_computer = 0;
                keep_driving = ~arrived & ~gas_tank_empty;
            end
        endcase
    end

    initial begin
        state = 0; // Initialize to Normal State
        shut_off_computer = 0;
        keep_driving = 0;
    end

endmodule