module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;  // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [23:0] out_bytes_reg;
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin  // IDLE
                if (in[3] == 1) begin
                    out_bytes_reg[23:16] <= in;
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done_reg <= 0;
            end
            1: begin  // BYTE1
                out_bytes_reg[15:8] <= in;
                state <= 2;
                done_reg <= 0;
            end
            2: begin  // BYTE2
                out_bytes_reg[7:0] <= in;
                state <= 3;
                done_reg <= 0;
            end
            3: begin  // BYTE3
                state <= 0;
                done_reg <= 1;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule