module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE (2'b00), SHIFT (2'b01)
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // SHIFT state
        counter <= 2'b00; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b01: begin // SHIFT state
                if (counter == 2'b11) begin // 4 clock cycles
                    state <= 2'b00; // IDLE state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b00: begin // IDLE state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule