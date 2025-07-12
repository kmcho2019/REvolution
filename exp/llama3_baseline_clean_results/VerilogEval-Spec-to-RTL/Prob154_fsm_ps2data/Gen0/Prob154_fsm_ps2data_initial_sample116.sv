module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                out_bytes_reg[15:8] <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                out_bytes_reg[7:0] <= in;
                done_reg <= 1'b1;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
        done_reg <= (state == BYTE2) ? 1'b1 : 1'b0;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg && (state == IDLE);

endmodule