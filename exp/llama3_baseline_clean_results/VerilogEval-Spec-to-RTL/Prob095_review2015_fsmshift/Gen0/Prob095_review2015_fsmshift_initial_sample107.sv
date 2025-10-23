module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE and SHIFT
reg [1:0] counter; // 4-cycle counter
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1; // go to SHIFT state
        counter <= 0; // reset counter
        shift_ena_reg <= 1; // assert shift_ena
    end else begin
        case (state)
            1'b1: begin // SHIFT state
                if (counter < 4) begin
                    counter <= counter + 1;
                    shift_ena_reg <= 1;
                end else begin
                    state <= 1'b0; // go to IDLE state
                    shift_ena_reg <= 0; // deassert shift_ena
                end
            end
            1'b0: begin // IDLE state
                shift_ena_reg <= 0; // keep shift_ena deasserted
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule