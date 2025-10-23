module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE (2'b00) and SHIFT (2'b01)
reg [1:0] counter; // counter to count 4 clock cycles
reg shift_ena_reg; // register to store the value of shift_ena

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // go to SHIFT state when reset is asserted
        counter <= 2'b00; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b01: begin // SHIFT state
                if (counter == 2'b11) begin // 4 clock cycles have passed
                    state <= 2'b00; // go back to IDLE state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1'b1; // increment counter
                end
            end
            default: begin // IDLE state
                shift_ena_reg <= 1'b0; // keep shift_ena deasserted
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule