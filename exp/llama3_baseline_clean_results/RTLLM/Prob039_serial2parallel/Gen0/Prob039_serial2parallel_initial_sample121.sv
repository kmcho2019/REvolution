module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin
        if (cnt < 4'd7) begin
            // Shift the input din_serial into the most significant bit position
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'd1;
            dout_valid <= 1'd0;
        end else begin
            // Update the output and reset the counter
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= 4'd0;
            dout_valid <= 1'd1;
        end
    end else begin
        // If din_valid is 0, do not update the output
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'd0;
    end
end

endmodule