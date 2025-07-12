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
reg [3:0] cnt;

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin
        if (cnt == 4'd7) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= 4'd0;
            dout_valid_reg <= 1'd1;
        end else begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'd1;
            dout_valid_reg <= 1'd0;
        end
    end else if (cnt == 4'd0) begin
        dout_valid_reg <= 1'd0;
    end
end

endmodule