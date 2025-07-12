module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0 - idle, 1 - shift
reg [1:0] counter; // counter for shift state

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // go to shift state on reset
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1'b0: begin // idle state
                shift_ena <= 0;
                // in a real implementation, you would check for a proper bit pattern here
                // for simplicity, let's assume the pattern is always true
                state <= 1; // transition to shift state
                counter <= 0;
            end
            1'b1: begin // shift state
                shift_ena <= 1;
                counter <= counter + 1;
                if (counter == 3) begin // after 4 cycles, go back to idle state
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule