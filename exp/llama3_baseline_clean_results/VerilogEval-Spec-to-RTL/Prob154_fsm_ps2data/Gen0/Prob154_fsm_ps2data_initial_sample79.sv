module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        case (state)
            2'b00: begin
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    nextState <= 2'b01;
                end else begin
                    nextState <= 2'b00;
                end
            end
            2'b01: begin
                out_bytes_reg[15:8] <= in;
                nextState <= 2'b10;
            end
            2'b10: begin
                out_bytes_reg[7:0] <= in;
                nextState <= 2'b11;
            end
            2'b11: begin
                done_reg <= 1'b1;
                nextState <= 2'b00;
            end
            default: nextState <= 2'b00;
        endcase
    end
end

assign out_bytes = (done_reg) ? out_bytes_reg : 24'd0;
assign done = done_reg;

endmodule