module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_cnt;
reg [23:0] shift_reg;
reg msg_start;

always @(posedge clk) begin
    if (reset) begin
        byte_cnt <= 2'b00;
        shift_reg <= 24'b0;
        msg_start <= 1'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1) begin
            msg_start <= 1'b1;
            byte_cnt <= 2'b01;
            shift_reg <= {in, 16'b0};
        end else if (msg_start && byte_cnt < 2'b11) begin
            shift_reg <= {shift_reg[15:0], in};
            byte_cnt <= byte_cnt + 1'b1;
        end

        if (byte_cnt == 2'b11) begin
            msg_start <= 1'b0;
            done <= 1'b1;
            out_bytes <= shift_reg;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule