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

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state_reg <= 1;
                end
            end
            1: begin // BYTE1
                out_bytes_reg[15:8] <= in;
                state_reg <= 2;
            end
            2: begin // BYTE2
                out_bytes_reg[7:0] <= in;
                state_reg <= 3;
            end
            3: begin // DONE
                done_reg <= 1;
                state_reg <= 0;
            end
            default: state_reg <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (!reset) begin
        if (state_reg!= 3) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule