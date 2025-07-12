module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: RECEIVE, 2: VERIFY_STOP
reg [2:0] bit_counter_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        out_byte_reg <= 8'd0;
        done_reg <= 0;
        bit_counter_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (~in) begin
                    state_reg <= 1;
                    bit_counter_reg <= 1;
                    out_byte_reg <= 1'b0;
                end
            end
            1: begin // RECEIVE
                out_byte_reg <= {out_byte_reg[6:0], in};
                bit_counter_reg <= bit_counter_reg + 1;
                if (bit_counter_reg == 8) begin
                    state_reg <= 2;
                end
            end
            2: begin // VERIFY_STOP
                done_reg <= in;
                if (in) begin
                    state_reg <= 0;
                end
            end
            default: begin
                state_reg <= 0;
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg && (state_reg == 2);

endmodule