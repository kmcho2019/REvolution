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
reg [3:0] cnt_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 4'd0;
        dout_valid_reg <= 1'b0;
        dout_parallel_reg <= 8'd0;
    end else if (din_valid) begin
        if (cnt_reg < 4'd8) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt_reg <= cnt_reg + 1'b1;
        end else begin
            cnt_reg <= 4'd0;
        end
        if (cnt_reg == 4'd8) begin
            dout_valid_reg <= 1'b1;
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end else begin
        if (cnt_reg == 4'd8) begin
            dout_valid_reg <= 1'b0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule