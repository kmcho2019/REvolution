module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] temp;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        temp <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            temp <= {temp[6:0], din_serial};
            cnt <= cnt + 1'd1;
            dout_valid <= 1'd0;
        end else begin
            cnt <= 4'd0;
            dout_parallel <= temp;
            dout_valid <= 1'd1;
        end
    end else begin
        cnt <= 4'd0;
        temp <= 8'd0;
        dout_valid <= 1'd0;
    end
end

endmodule