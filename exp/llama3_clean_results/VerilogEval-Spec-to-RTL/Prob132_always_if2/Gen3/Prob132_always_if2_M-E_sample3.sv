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
            2'b00: begin // IDLE state
                shut_off_computer = 0;
                if (cpu_overheated) begin
                    state = 2'b01; // Transition to SHUTDOWN state
                end
            end
            2'b01: begin // SHUTDOWN state
                shut_off_computer = 1;
            end
            default: begin
                state = 2'b00; // Reset to IDLE state
            end
        endcase
    end

    always @(*) begin
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end else begin
            keep_driving = 0;
        end
    end

    initial begin
        state = 2'b00; // Initialize to IDLE state
    end

endmodule