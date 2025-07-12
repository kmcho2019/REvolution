module TopModule(
    input         clk,
    input         reset,
    output        shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: RESET
reg [1:0] counter; // counter to keep track of clock cycles after reset

always @(posedge clk) begin
    if (reset) begin
        state <= 2; // reset state
        counter <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0;
                state <= 2'b00;
            end
            2'b01: begin // SHIFT state (this state won't be used, keeping for completeness)
                shift_ena <= 1'b1;
                state <= 2'b01;
            end
            2'b10: begin // RESET state
                shift_ena <= 1'b1;
                counter <= counter + 1;
                if (counter == 4'd3) begin
                    state <= 2'b00;
                    shift_ena <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule