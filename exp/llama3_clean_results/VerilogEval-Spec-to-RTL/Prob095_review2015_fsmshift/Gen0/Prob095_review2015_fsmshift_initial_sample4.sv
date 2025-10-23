module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles
reg state; // FSM state: 0 - IDLE, 1 - SHIFT_ENABLE

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1'b1; // go to SHIFT_ENABLE state
        counter <= 2'd0; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else if (state == 1'b1) begin // in SHIFT_ENABLE state
        if (counter == 2'd3) begin // 4 clock cycles have passed
            state <= 1'b0; // go back to IDLE state
            shift_ena <= 1'b0; // deassert shift_ena
        end else begin
            counter <= counter + 1'b1; // increment counter
        end
    end else begin // in IDLE state
        shift_ena <= 1'b0; // deassert shift_ena
    end
end

endmodule