module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // Idle (0), ShiftEnable (1)
reg [1:0] counter; // Counter for 4 cycles
reg shift_ena_reg; // Registered shift_ena signal

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // ShiftEnable state
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // ShiftEnable state
                if (counter == 3) begin
                    state <= 0; // Transition to Idle state
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // Idle state
                counter <= 0;
            end
            default: begin
                state <= 0; // Default state
                counter <= 0;
            end
        endcase
    end
end

assign shift_ena = (state == 1) ? 1 : 0;

endmodule