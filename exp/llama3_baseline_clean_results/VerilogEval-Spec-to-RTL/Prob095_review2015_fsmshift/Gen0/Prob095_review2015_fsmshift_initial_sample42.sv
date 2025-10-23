module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting (counter)
reg [1:0] counter; // counter to keep track of clock cycles in shifting state
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1; // enter shifting state on reset
        counter <= 0; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena on reset
    end else begin
        case (state)
            1'b1: begin // shifting state
                if (counter == 4'd3) begin // 4 cycles have passed
                    state <= 1'b0; // transition to idle state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            1'b0: begin // idle state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule