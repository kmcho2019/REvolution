module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // using a 3-bit counter
reg [7:0] dout_parallel_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 3'b111) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end else begin
            cnt <= 3'b000;
            dout_valid_reg <= 1'b1;
        end
        dout_parallel <= dout_parallel_reg;
        dout_valid <= dout_valid_reg;
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= 1'b0;
        dout_parallel <= dout_parallel_reg;
        dout_valid <= dout_valid_reg;
    end
end

endmodule