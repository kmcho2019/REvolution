module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
        cnt <= 4'd0;
    end else if (din_valid) begin
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        cnt <= cnt + 1'd1;
        if (cnt == 4'd7) begin
            dout_valid_reg <= 1'd1;
            cnt <= 4'd0;
        end else begin
            dout_valid_reg <= 1'd0;
        end
    end else begin
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= 1'd0;
        cnt <= cnt;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule