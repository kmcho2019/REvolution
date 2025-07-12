module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel;
reg dout_valid;
reg [3:0] cnt;
reg [7:0] dout_parallel_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_valid <= 1'b0;
        dout_parallel_reg <= 8'd0;
    end else if (din_valid) begin
        if (cnt == 4'd8) begin
            cnt <= 4'd0;
            dout_valid <= 1'b1;
            dout_parallel_reg <= dout_parallel_reg;
        end else begin
            cnt <= cnt + 4'd1;
            dout_valid <= 1'b0;
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
        end
    end else begin
        cnt <= cnt;
        dout_valid <= dout_valid;
        dout_parallel_reg <= dout_parallel_reg;
    end
end

assign dout_parallel = dout_parallel_reg;

endmodule