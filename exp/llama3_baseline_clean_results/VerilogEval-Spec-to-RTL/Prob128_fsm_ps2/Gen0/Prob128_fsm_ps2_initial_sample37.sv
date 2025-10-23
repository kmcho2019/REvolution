module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // idle, byte1, byte2, byte3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // idle state
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (in[3]) begin // start byte detected
                    state <= 2'b01; // move to byte1 state
                end
            end
            2'b01: begin // byte1 state
                state <= 2'b10; // move to byte2 state
            end
            2'b10: begin // byte2 state
                state <= 2'b11; // move to byte3 state
            end
            2'b11: begin // byte3 state
                state <= 2'b00; // move back to idle state
                done_reg <= 1'b1;
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (reset || (state!= 2'b11)) begin
        done_reg <= 1'b0;
    end
end

endmodule