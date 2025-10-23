module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;

always @ (posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (in[3] == 1'b1) begin
                    out_bytes_reg[7:0] <= in;
                    state_reg <= 1;
                end else begin
                    state_reg <= 0;
                end
                done_reg <= 1'b0;
            end
            1: begin // BYTE1
                out_bytes_reg[15:8] <= in;
                state_reg <= 2;
                done_reg <= 1'b0;
            end
            2: begin // BYTE2
                out_bytes_reg[23:16] <= in;
                state_reg <= 3;
                done_reg <= 1'b0;
            end
            3: begin // BYTE3
                state_reg <= 0;
                done_reg <= 1'b1;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule