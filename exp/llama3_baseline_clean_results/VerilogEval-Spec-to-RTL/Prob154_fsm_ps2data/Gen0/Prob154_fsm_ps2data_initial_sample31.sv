module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

parameter IDLE = 2'b00;
parameter BYTE_1 = 2'b01;
parameter BYTE_2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in;
                    state <= BYTE_1;
                end
            end
            BYTE_1: begin
                out_bytes_reg[15:8] <= in;
                state <= BYTE_2;
            end
            BYTE_2: begin
                out_bytes_reg[7:0] <= in;
                done_reg <= 1'b1;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule