module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (in[3]) begin
                    out_bytes_reg[7:0] <= in;
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
                done_reg <= 1'b0;
            end
            2'b01: begin
                out_bytes_reg[15:8] <= in;
                state <= 2'b10;
                done_reg <= 1'b0;
            end
            2'b10: begin
                out_bytes_reg[23:16] <= in;
                state <= 2'b00;
                done_reg <= 1'b1;
            end
            default: begin
                state <= 2'b00;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule