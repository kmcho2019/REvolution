module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] counter;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        counter <= 2'b00;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    out_bytes_reg <= {in, 16'b0};
                    counter <= 2'b01;
                    state <= 2'b01;
                end
            end
            2'b01: begin // RECEIVING
                if (counter == 2'b01) begin
                    out_bytes_reg <= {out_bytes_reg[15:0], in};
                    counter <= 2'b10;
                end else if (counter == 2'b10) begin
                    out_bytes_reg <= {out_bytes_reg[7:0], in, out_bytes_reg[15:8]};
                    counter <= 2'b11;
                    state <= 2'b00;
                    done_reg <= 1'b1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        done_reg <= 1'b0;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule