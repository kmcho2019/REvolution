module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] buffer_reg;
reg [7:0] dout_parallel_reg;
reg [2:0] cnt;
reg [2:0] cnt_next;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        buffer_reg <= 8'b00000000;
        dout_parallel_reg <= 8'b00000000;
        cnt <= 3'b000;
        dout_valid <= 1'b0;
    end else begin
        if (din_valid) begin
            buffer_reg <= {din_serial, buffer_reg[7:1]};
            cnt <= cnt + 1'b1;
        end else begin
            buffer_reg <= buffer_reg;
            cnt <= cnt;
        end

        if (cnt == 3'b111) begin
            dout_parallel_reg <= buffer_reg;
            dout_valid <= 1'b1;
            cnt <= 3'b000;
        end else if (cnt == 3'b000) begin
            dout_valid <= 1'b0;
        end

        dout_parallel <= dout_parallel_reg;
    end
end

endmodule