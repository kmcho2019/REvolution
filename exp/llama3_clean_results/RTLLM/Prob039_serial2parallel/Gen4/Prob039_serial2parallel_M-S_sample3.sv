module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        cnt <= (cnt == 3'b111) ? 3'b000 : cnt + 1'b1;
        dout_parallel_reg <= (cnt == 3'b111) ? {din_serial, dout_parallel_reg[7:1]} : {dout_parallel_reg[6:0], din_serial};
        dout_valid_reg <= (cnt == 3'b111) ? 1'b1 : 1'b0;
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule