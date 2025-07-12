module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

parameter IDLE = 2'b01;
parameter BYTE1 = 2'b10;
parameter BYTE2 = 2'b11;

reg [1:0] state;
reg [23:0] next_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_out_bytes[23:16] <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                next_out_bytes[15:8] <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                next_out_bytes[7:0] <= in;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
        out_bytes <= next_out_bytes;
    end
end

assign done = (state == BYTE2);

endmodule