module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg [23:0] out_bytes_reg;
reg [23:0] next_out_bytes;
reg done_reg;
reg next_done;

always @(*) begin
    next_state = state;
    next_out_bytes = out_bytes_reg;
    next_done = 0;

    case(state)
        2'b00: begin // idle
            if (in[3] == 1'b1) begin
                next_state = 2'b01;
                next_out_bytes = {in, 16'd0};
            end
        end
        2'b01: begin // byte1
            next_state = 2'b10;
            next_out_bytes = {out_bytes_reg[15:0], in};
        end
        2'b10: begin // byte2
            next_state = 2'b11;
            next_out_bytes = {out_bytes_reg[15:8], out_bytes_reg[7:0], in};
        end
        2'b11: begin // byte3
            next_state = 2'b00;
            next_done = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        out_bytes_reg <= next_out_bytes;
        done_reg <= next_done;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule