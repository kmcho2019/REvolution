module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;  // Reset counter
        dout_parallel <= 8'd0;  // Reset parallel output
        dout_valid <= 1'd0;  // Reset output validity
    end else if (din_valid) begin
        if (cnt == 4'd7) begin
            cnt <= 4'd0;  // Reset counter after 8 bits
            dout_valid <= 1'd1;  // Set output validity
        end else begin
            cnt <= cnt + 1'd1;  // Increment counter
            dout_valid <= 1'd0;  // Clear output validity until 8 bits received
        end

        // Shift received serial data into place in parallel output
        dout_parallel <= {dout_parallel[6:0], din_serial};
    end
end

endmodule