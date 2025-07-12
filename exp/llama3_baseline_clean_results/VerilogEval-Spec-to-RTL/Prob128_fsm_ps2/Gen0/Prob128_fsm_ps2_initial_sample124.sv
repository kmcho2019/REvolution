module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // Transition to BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // Transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // Transition to BYTE3 state
            end
            2'b11: begin // BYTE3 state
                done_reg <= 1'b1; // Set done signal high
                state <= 2'b00; // Transition back to IDLE state
            end
        endcase
    end
end

assign done = done_reg;

endmodule