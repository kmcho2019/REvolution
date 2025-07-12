module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles in SHIFT state
reg state; // 0 for IDLE, 1 for SHIFT

always @(posedge clk) begin
    if (reset) begin // reset is active high synchronous
        state <= 1'b1; // enter SHIFT state
        counter <= 2'd0; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else begin
        if (state == 1'b1) begin // in SHIFT state
            counter <= counter + 1; // increment counter
            shift_ena <= 1'b1; // assert shift_ena
            if (counter == 4'd3) begin // after 4 clock cycles
                state <= 1'b0; // transition to IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
        end else begin // in IDLE state
            shift_ena <= 1'b0; // deassert shift_ena
        end
    end
end

endmodule