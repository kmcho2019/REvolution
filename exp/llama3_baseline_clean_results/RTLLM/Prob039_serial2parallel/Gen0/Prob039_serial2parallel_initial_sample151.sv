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
reg [3:0] cnt_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
        cnt_reg <= 4'b0;
    end else if (din_valid) begin
        if (cnt_reg == 4'd7) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            dout_valid_reg <= 1'b1;
            cnt_reg <= 4'b0;
        end else begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt_reg <= cnt_reg + 1'b1;
            dout_valid_reg <= 1'b0;
        end
    end else begin
        cnt_reg <= 4'b0;
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule