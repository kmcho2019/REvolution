module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2: COUNT_1, 3: COUNT_2
reg [1:0] counter; // counter to count 4 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // transition to SHIFT_ENABLE state on reset
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena on reset
    end else begin
        case (state)
            1: begin // SHIFT_ENABLE state
                if (counter == 3) begin
                    state <= 0; // transition to IDLE state after 4 clock cycles
                    shift_ena <= 0; // deassert shift_ena
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            0: begin // IDLE state
                // do nothing
            end
        endcase
    end
end

endmodule