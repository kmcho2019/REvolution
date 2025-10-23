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
reg [7:0] shift_reg;

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
        cnt_reg <= 4'd0;
        shift_reg <= 8'd0;
    end else if (din_valid) begin
        shift_reg <= {din_serial, shift_reg[7:1]};
        cnt_reg <= cnt_reg + 1;
        if (cnt_reg == 4'd8) begin
            cnt_reg <= 4'd0;
            dout_parallel_reg <= shift_reg;
            dout_valid_reg <= 1'd1;
        end else begin
            dout_valid_reg <= 1'd0;
        end
    end else begin
        dout_valid_reg <= 1'd0;
    end
end

endmodule