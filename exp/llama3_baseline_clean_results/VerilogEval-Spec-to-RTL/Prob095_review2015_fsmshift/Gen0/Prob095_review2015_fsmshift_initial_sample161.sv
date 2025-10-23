module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE (0) and SHIFT (1)
reg [1:0] count; // counter for SHIFT state
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1; // go to SHIFT state
        count <= 0; // reset counter
        shift_ena_reg <= 1; // assert shift_ena
    end else begin
        case (state)
            1: begin // SHIFT state
                if (count == 3) begin // 4 cycles have passed
                    state <= 0; // go back to IDLE state
                    shift_ena_reg <= 0; // deassert shift_ena
                end else begin
                    count <= count + 1; // increment counter
                end
            end
            default: begin // IDLE state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule