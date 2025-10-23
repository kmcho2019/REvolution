module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 00 - idle, 01 - byte1, 10 - byte2, 11 - byte3
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // idle state
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to byte1 state
                end else begin
                    state <= 2'b00; // stay in idle state
                end
                done_reg <= 1'b0;
            end
            2'b01: begin // byte1 state
                state <= 2'b10; // transition to byte2 state
                done_reg <= 1'b0;
            end
            2'b10: begin // byte2 state
                state <= 2'b11; // transition to byte3 state
                done_reg <= 1'b0;
            end
            2'b11: begin // byte3 state
                state <= 2'b00; // transition back to idle state
                done_reg <= 1'b1;
            end
        endcase
    end
end

assign done = done_reg;

endmodule