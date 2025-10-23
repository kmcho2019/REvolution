module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 2 states: idle (0) and shifting (1)
reg [1:0] counter; // counter to keep track of clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // enter shifting state when reset is asserted
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena
    end else begin
        case (state)
            1'b0: begin // idle state
                shift_ena <= 0; // keep shift_ena low
            end
            1'b1: begin // shifting state
                if (counter < 4) begin // check if 4 cycles have passed
                    counter <= counter + 1; // increment counter
                    shift_ena <= 1; // keep shift_ena high
                end else begin
                    state <= 0; // enter idle state after 4 cycles
                    shift_ena <= 0; // deassert shift_ena
                end
            end
        endcase
    end
end

endmodule