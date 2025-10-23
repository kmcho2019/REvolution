module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE (0) and SHIFT_ENABLE (1)
reg [1:0] counter; // counter to keep track of clock cycles in SHIFT_ENABLE state

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // enter SHIFT_ENABLE state on reset
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena on reset
    end else begin
        case (state)
            1'b1: begin // SHIFT_ENABLE state
                if (counter == 3) begin // if 4 clock cycles have passed
                    state <= 1'b0; // transition to IDLE state
                    shift_ena <= 1'b0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                    shift_ena <= 1'b1; // assert shift_ena
                end
            end
            1'b0: begin // IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
        endcase
    end
end

endmodule