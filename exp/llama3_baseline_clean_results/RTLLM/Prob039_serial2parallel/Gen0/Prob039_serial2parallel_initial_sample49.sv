module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        dout_parallel <= 0;
        dout_valid <= 0;
    end else if (din_valid) begin
        if (cnt < 4'd7) begin
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            cnt <= cnt + 1;
            dout_valid <= 0;
        end else if (cnt == 4'd7) begin
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            cnt <= 0;
            dout_valid <= 1;
        end
    end else begin
        if (cnt == 4'd7) begin
            dout_valid <= 0;
        end
    end
end

endmodule