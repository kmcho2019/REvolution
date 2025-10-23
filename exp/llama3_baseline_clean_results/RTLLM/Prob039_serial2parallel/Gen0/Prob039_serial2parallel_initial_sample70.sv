module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_int;
reg [3:0] cnt;
reg dout_valid_int;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel_int <= 8'd0;
        dout_valid_int <= 1'd0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            dout_parallel_int <= {dout_parallel_int[6:0], din_serial};
            cnt <= cnt + 1;
            dout_valid_int <= 1'd0;
        end else begin
            cnt <= 4'd0;
            dout_valid_int <= 1'd1;
        end
    end else begin
        cnt <= 4'd0;
        dout_parallel_int <= 8'd0;
        dout_valid_int <= 1'd0;
    end
end

assign dout_parallel = dout_parallel_int;
assign dout_valid = (cnt == 4'd8) ? 1'd1 : dout_valid_int;

endmodule