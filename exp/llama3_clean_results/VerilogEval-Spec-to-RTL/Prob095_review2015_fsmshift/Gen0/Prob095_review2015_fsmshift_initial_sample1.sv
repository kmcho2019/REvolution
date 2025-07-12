module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0 - IDLE, 1 - SHIFT_ENA, 2 - RESET_ENA
reg [1:0] counter; // Counter to keep track of shift_ena cycles
reg shift_ena_reg; // Register for shift_ena output

always @(posedge clk) begin
    if (reset) begin
        state <= 2; // Go to RESET_ENA state upon reset
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (counter == 4'd4) begin
                    state <= 2'b00; // Stay in IDLE if counter reaches 4
                    counter <= 0;
                    shift_ena_reg <= 0;
                end else if (reset) begin // If reset during IDLE, go to RESET_ENA
                    state <= 2'b10;
                    counter <= 0;
                    shift_ena_reg <= 1;
                end
            end
            2'b01: begin // SHIFT_ENA state
                if (counter == 4'd4) begin
                    state <= 2'b00; // Go back to IDLE after 4 cycles
                    counter <= 0;
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1; // Increment counter
                end
                shift_ena_reg <= 1; // Keep shift_ena high during SHIFT_ENA state
            end
            2'b10: begin // RESET_ENA state
                if (counter == 4'd4) begin
                    state <= 2'b00; // Go to IDLE after 4 cycles
                    counter <= 0;
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1; // Increment counter
                end
                shift_ena_reg <= 1; // Keep shift_ena high during RESET_ENA state
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule