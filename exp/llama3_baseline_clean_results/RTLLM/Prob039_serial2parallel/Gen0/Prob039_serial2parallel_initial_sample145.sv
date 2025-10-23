module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin // valid input data
        if (cnt == 4'd7) begin // 8 bits received
            cnt <= 4'd0;
            dout_valid <= 1'd1;
        end else begin
            cnt <= cnt + 4'd1;
            dout_valid <= 1'd0;
        end
        // shift in serial data
        dout_parallel <= {dout_parallel[6:0], din_serial};
    end else begin // no valid input data
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        if (cnt == 4'd7) begin
            dout_valid <= 1'd1;
        end else begin
            dout_valid <= 1'd0;
        end
    end
end

endmodule