module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE
reg [7:0] byte1, byte2, byte3;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3; // DONE
            end
            3: begin // DONE
                done_reg <= 1;
                state <= 0; // IDLE
            end
        endcase
    end
end

assign done = done_reg;
assign out_bytes = (done_reg) ? {byte1, byte2, byte3} : 24'd0;

endmodule