module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // state variable for the FSM
reg [1:0] counter; // counter to keep track of the number of clock cycles in SHIFT state

always @(posedge clk) begin
    if (reset) begin // if reset is high, transition to SHIFT state
        state <= 2'b01; // SHIFT state
        counter <= 2'd0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0;
                if (reset) begin // if reset is high, transition to SHIFT state
                    state <= 2'b01;
                    counter <= 2'd0;
                    shift_ena <= 1'b1;
                end
            end
            2'b01: begin // SHIFT state
                shift_ena <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 2'd3) begin // if 4 clock cycles have passed, transition to IDLE state
                    state <= 2'b00;
                    shift_ena <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // default to IDLE state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule