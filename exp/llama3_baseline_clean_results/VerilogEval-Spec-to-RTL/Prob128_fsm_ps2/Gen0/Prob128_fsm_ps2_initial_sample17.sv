module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b00; // IDLE
                done_reg <= 1'b1;
            end
            default: begin
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (~reset) begin
        if (state == 2'b00 && ~done_reg) begin
            done_reg <= 1'b0;
        end
    end
end

endmodule