module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [3:0] cnt;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            cnt <= cnt + 1'd1;
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
        end else begin
            cnt <= 4'd0;
            dout_parallel_reg <= 8'd0;
            dout_valid_reg <= 1'd1;
        end
    end else begin
        // Do nothing when din_valid is low, to minimize switching
    end
end

// Reset dout_valid_reg when cnt resets to 0
always @(posedge clk) begin
    if (cnt == 4'd0 && ~din_valid) begin
        dout_valid_reg <= 1'd0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule