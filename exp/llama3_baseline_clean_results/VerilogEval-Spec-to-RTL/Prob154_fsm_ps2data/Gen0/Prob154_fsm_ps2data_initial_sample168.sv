module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;
reg [1:0] state_next;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (in[3] == 1'b1) begin
                state_next = BYTE1;
                out_bytes_reg = {in, 16'b0};
            end else begin
                state_next = IDLE;
                out_bytes_reg = out_bytes_reg;
            end
        end
        BYTE1: begin
            state_next = BYTE2;
            out_bytes_reg = {out_bytes_reg[15:0], in};
        end
        BYTE2: begin
            state_next = BYTE3;
            out_bytes_reg = {out_bytes_reg[7:0], in, 8'b0};
        end
        BYTE3: begin
            state_next = IDLE;
            out_bytes_reg = out_bytes_reg;
        end
        default: begin
            state_next = IDLE;
            out_bytes_reg = out_bytes_reg;
        end
    endcase
end

always @(*) begin
    if (state_reg == BYTE3) begin
        done_reg = 1'b1;
    end else begin
        done_reg = 1'b0;
    end
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state_reg <= IDLE;
        out_bytes_reg <= 24'b0;
    end else begin
        state_reg <= state_next;
        out_bytes_reg <= out_bytes_reg;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule