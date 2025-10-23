module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state;

    always @(*) begin
        case (state)
            2'b00: begin // Normal state
                if (cpu_overheated) begin
                    state = 2'b10; // Shutdown computer
                end else if (!arrived && !gas_tank_empty) begin
                    state = 2'b01; // Keep driving
                end
            end
            2'b01: begin // Driving state
                if (arrived || gas_tank_empty) begin
                    state = 2'b00; // Stop driving
                end
            end
            2'b10: begin // Shutdown state
                if (!cpu_overheated) begin
                    state = 2'b00; // Restart computer
                end
            end
            default: begin // Invalid state
                state = 2'b00; // Reset to normal state
            end
        endcase
    end

    always @(*) begin
        shut_off_computer = state[1];
        keep_driving = state[0];
    end

endmodule