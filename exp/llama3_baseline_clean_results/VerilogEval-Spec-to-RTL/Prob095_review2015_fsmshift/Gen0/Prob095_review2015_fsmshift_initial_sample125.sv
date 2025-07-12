module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 2 states: IDLE (2'b00) and SHIFT (2'b01)
reg [1:0] counter; // counter to keep track of clock cycles in SHIFT state

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // go to SHIFT state when reset
        counter <= 2'b00; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            1'b1: begin // SHIFT state
                if (counter == 2'b11) begin // 4 clock cycles have passed
                    state <= 1'b0; // go to IDLE state
                    shift_ena <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1'b1; // increment counter
                end
            end
            default: begin // IDLE state
                state <= 1'b0; // stay in IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
        endcase
    end
end

endmodule