module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [7:0] byte1_reg, byte2_reg;
reg [1:0] state_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0;
        done_reg <= 0;
        out_bytes_reg <= 0;
        byte1_reg <= 0;
        byte2_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE state
                if (in[3] == 1) begin
                    state_reg <= 1;
                    byte1_reg <= in;
                end
                done_reg <= 0;
            end
            1: begin // FIRST_BYTE state
                state_reg <= 2;
                byte2_reg <= in;
            end
            2: begin // SECOND_BYTE state
                state_reg <= 0;
                out_bytes_reg <= {byte1_reg, byte2_reg, in};
                done_reg <= 1;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule