module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // Reduced counter size to 3 bits, as we only need 8 states

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 3'b111) begin // Check if counter has reached 8
            // Shift in the new bit and increment counter
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'b1;
            dout_valid <= 1'b0;
        end else begin
            // Reset counter and set dout_valid to 1
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end
    end else begin
        // Only update dout_valid when cnt is full and din_valid is low
        // to reduce switching activity
        if (cnt == 3'b111 && din_valid == 1'b0) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
        // No need to update cnt or dout_parallel when din_valid is low
    end
end

endmodule