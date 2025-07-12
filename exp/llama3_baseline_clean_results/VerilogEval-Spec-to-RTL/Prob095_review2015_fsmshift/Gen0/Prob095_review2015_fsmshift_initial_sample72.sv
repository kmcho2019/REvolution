module TopModule(
    input        clk,
    input        reset,
    output       shift_ena
);

reg [1:0] state; // 2 states: IDLE (0) and SHIFT (1)
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // transition to SHIFT state on reset
        counter <= 0; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            1'b1: begin // SHIFT state
                if (counter == 4'd3) begin // 4 clock cycles
                    state <= 1'b0; // transition back to IDLE state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                    shift_ena_reg <= 1'b1; // assert shift_ena
                end
            end
            1'b0: begin // IDLE state
                shift_ena_reg <= 1'b0; // deassert shift_ena
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule