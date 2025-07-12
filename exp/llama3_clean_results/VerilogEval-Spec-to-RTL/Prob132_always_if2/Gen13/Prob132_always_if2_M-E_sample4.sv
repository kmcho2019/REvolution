module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state;

    always @(*) begin
        case(state)
            2'b00: begin // Normal state
                if (cpu_overheated) begin
                    state = 2'b01; // Transition to shut down state
                end else begin
                    keep_driving = ~arrived && ~gas_tank_empty;
                end
            end
            2'b01: begin // Shut down state
                shut_off_computer = 1'b1;
                if (~cpu_overheated) begin
                    state = 2'b00; // Transition back to normal state
                end
            end
            default: begin
                state = 2'b00; // Default to normal state
            end
        endcase
    end

    initial begin
        state = 2'b00; // Initialize to normal state
        shut_off_computer = 1'b0;
    end

endmodule