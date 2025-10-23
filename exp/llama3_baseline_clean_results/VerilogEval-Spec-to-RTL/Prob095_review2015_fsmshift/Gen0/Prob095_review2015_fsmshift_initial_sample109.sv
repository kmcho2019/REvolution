module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2-bit state register
reg [1:0] counter; // 2-bit counter
reg shift_ena_reg; // register for shift_ena

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 2'b01; // go to shifting state
        counter <= 2'b00; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b01: begin // shifting state
                if (counter == 2'b11) begin // check if 4 cycles have passed
                    state <= 2'b00; // go to idle state
                    shift_ena_reg <= 1'b0; // de-assert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            2'b00: begin // idle state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule