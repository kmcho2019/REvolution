module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: idle (0), shifting (1, 2, 3)
reg [1:0] counter;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Start shifting on reset
        counter <= 2'b00; // Reset counter
        shift_ena <= 1'b1; // Enable shift
    end else begin
        case (state)
            2'b01: begin // First cycle of shifting
                if (counter == 4'b100) begin // Counter wraps around at 4
                    state <= 2'b00; // Go back to idle after 4 cycles
                    shift_ena <= 1'b0; // Disable shift
                end else begin
                    counter <= counter + 1'b1; // Increment counter
                    state <= state; // Stay in shifting state
                    shift_ena <= 1'b1; // Keep shifting enabled
                end
            end
            2'b00: begin // Idle state
                state <= state; // Stay idle
                shift_ena <= 1'b0; // Keep shift disabled
            end
        endcase
    end
end

endmodule