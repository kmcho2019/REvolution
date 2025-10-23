module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shift, 2: shift (counter), 3: shift (counter)
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // transition to shift state on reset
        counter <= 0; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena on reset
    end else begin
        case (state)
            1'b1: begin // shift state
                if (counter == 4'd3) begin // after 4 cycles
                    state <= 1'b0; // transition back to idle state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    state <= state; // stay in shift state
                    counter <= counter + 1; // increment counter
                    shift_ena_reg <= 1'b1; // keep shift_ena asserted
                end
            end
            1'b0: begin // idle state
                state <= state; // stay in idle state
                counter <= 0; // reset counter
                shift_ena_reg <= 1'b0; // keep shift_ena deasserted
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule