module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 2 states: initial and shifting
reg [1:0] counter; // counter for 4 cycles
reg shift_ena_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b01; // initial state
        counter <= 2'b00; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b01: begin // initial state
                if (counter == 4'b100) begin
                    state <= 2'b10; // shifting state
                    shift_ena_reg <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1'b1; // increment counter
                end
            end
            2'b10: begin // shifting state
                // do nothing, just stay in this state
            end
            default: begin
                state <= 2'b01; // default to initial state
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule