module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [3:0] cnt;
reg [7:0] dout_parallel_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'b1000) begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end else begin
            cnt <= 4'b0000;
            dout_valid_reg <= 1'b1;
        end
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        if (cnt == 4'b1000) begin
            dout_valid_reg <= 1'b1;
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule