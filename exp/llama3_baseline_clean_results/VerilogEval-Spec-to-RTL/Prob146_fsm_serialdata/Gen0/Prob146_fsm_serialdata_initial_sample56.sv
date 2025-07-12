module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte_reg;
reg [2:0] bit_cnt;
reg [1:0] state;
reg [7:0] out_byte_reg;

parameter IDLE = 2'b00;
parameter RECV_BIT = 2'b01;
parameter STOP_CHECK = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_cnt <= 3'b000;
        out_byte_reg <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= RECV_BIT;
                    bit_cnt <= 3'b000;
                    out_byte_reg <= 8'b0;
                end
            end
            RECV_BIT: begin
                out_byte_reg[bit_cnt] <= in;
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 8) begin
                    state <= STOP_CHECK;
                end
            end
            STOP_CHECK: begin
                if (in) begin
                    state <= IDLE;
                    done <= 1'b1;
                    byte_reg <= out_byte_reg;
                end else begin
                    state <= STOP_CHECK;
                end
            end
        endcase
    end
end

assign out_byte = byte_reg;
assign done = (state == STOP_CHECK && in);

endmodule