module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to count the number of serial input data bits received

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            dout_parallel <= {dout_parallel[6:0], din_serial}; // shift left and add new data bit
            cnt <= cnt + 1'b1; // increment counter
            dout_valid <= 1'b0; // set dout_valid to 0 until all 8 bits are received
        end else begin
            cnt <= 4'd0; // reset counter
            dout_valid <= 1'b1; // set dout_valid to 1 when all 8 bits are received
        end
    end else begin
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        if (cnt == 4'd8) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule