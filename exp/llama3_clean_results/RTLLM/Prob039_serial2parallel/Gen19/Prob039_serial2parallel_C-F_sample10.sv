module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'b1000) begin
            {dout_parallel[6:0], din_serial} <= dout_parallel;
            cnt <= cnt + 1'b1;
            dout_valid <= 1'b0;
        end else begin
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end
    end else begin
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule