module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [2:0] bit_pos;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        bit_pos <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        dout_parallel[7 - bit_pos] <= din_serial;
        if (cnt < 4'b1000) begin
            cnt <= cnt + 1'b1;
            bit_pos <= bit_pos + 1'b1;
        end else begin
            cnt <= 4'b0000;
            bit_pos <= 3'b000;
            dout_valid <= 1'b1;
        end
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule