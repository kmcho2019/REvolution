module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 2 states: IDLE (2'b00) and SHIFT (2'b01, 2'b10, 2'b11)
reg [1:0] count; // counter to keep track of clock cycles in SHIFT state

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // transition to SHIFT state on reset
        count <= 2'b00; // reset counter
        shift_ena <= 1'b1; // assert shift_ena
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0; // deassert shift_ena
            end
            2'b01, 2'b10, 2'b11: begin // SHIFT state
                shift_ena <= 1'b1; // assert shift_ena
                count <= count + 1'b1; // increment counter
                if (count == 2'b11) begin // 4 clock cycles have passed
                    state <= 2'b00; // transition to IDLE state
                    shift_ena <= 1'b0; // deassert shift_ena
                end else begin
                    state <= state + 1'b1; // increment state
                end
            end
        endcase
    end
end

endmodule