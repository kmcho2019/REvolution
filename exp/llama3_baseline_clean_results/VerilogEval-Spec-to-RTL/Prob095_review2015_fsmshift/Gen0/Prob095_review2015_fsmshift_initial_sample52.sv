module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2-state FSM: idle (0) and shifting (1, 2, 3)
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg; // register to store the output

always @(posedge clk) begin
    if (reset) begin // reset is active high synchronous
        state <= 1; // start shifting
        counter <= 1; // start counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            1: begin // shifting
                if (counter == 4) begin
                    state <= 0; // return to idle
                    counter <= 0; // reset counter
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            0: begin // idle
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule