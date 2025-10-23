module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // state register (0: idle, 1: shifting)
reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if (reset) begin // if reset is high, transition to shifting state and reset counter
        state <= 1'b1;
        counter <= 2'd0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1'b0: begin // idle state, do nothing
                shift_ena <= 1'b0;
            end
            1'b1: begin // shifting state, increment counter and check if 4 cycles have passed
                shift_ena <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 4) begin // if 4 cycles have passed, transition to idle state
                    state <= 1'b0;
                end
            end
        endcase
    end
end

endmodule