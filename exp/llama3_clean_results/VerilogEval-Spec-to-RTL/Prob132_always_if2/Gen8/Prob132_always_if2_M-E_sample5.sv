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
            2'b00: begin // Normal operating state
                shut_off_computer = 0;
                keep_driving = ~arrived & ~gas_tank_empty;
                if (cpu_overheated) begin
                    state = 2'b01; // Transition to shutdown state
                end
            end
            2'b01: begin // Shutdown state
                shut_off_computer = 1;
                keep_driving = 0;
            end
            2'b10: begin // Driving state
                shut_off_computer = 0;
                keep_driving = ~gas_tank_empty;
                if (arrived) begin
                    state = 2'b00; // Transition to normal operating state
                end
            end
            default: begin
                state = 2'b00; // Default to normal operating state
            end
        endcase
    end

    initial begin
        state = 2'b00; // Initialize to normal operating state
    end

endmodule