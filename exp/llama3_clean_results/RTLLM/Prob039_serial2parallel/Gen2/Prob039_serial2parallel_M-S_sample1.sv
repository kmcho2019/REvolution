module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        {dout_parallel, din_serial} <= {dout_parallel, din_serial} >> 1;
        cnt <= cnt + 1;
        if (cnt == 8) begin
            cnt <= 0;
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule