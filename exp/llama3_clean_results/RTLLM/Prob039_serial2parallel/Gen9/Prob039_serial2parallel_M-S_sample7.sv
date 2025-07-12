module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        dout_parallel <= {dout_parallel[6:0], din_serial};
        cnt <= cnt + 1'b1;
        if (cnt == 3'b111) begin
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        cnt <= cnt;
        dout_valid <= 1'b0;
    end
end

endmodule