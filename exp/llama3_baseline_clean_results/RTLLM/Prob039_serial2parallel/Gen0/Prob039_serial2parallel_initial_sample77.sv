module serial2parallel(
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input din_serial, // Serial input data
    input din_valid,  // Validity signal for input data
    output reg [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output reg dout_valid          // Validity signal for the output data
);

reg [2:0] cnt; // 3-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'd0; // Reset counter to 0
        dout_parallel <= 8'd0; // Reset parallel output data to 0
        dout_valid <= 1'd0; // Reset output valid signal to 0
    end else if (din_valid) begin
        if (cnt == 3'd7) begin
            // Output parallel data and set dout_valid to 1
            dout_parallel <= {dout_parallel[6:0], din_serial};
            dout_valid <= 1'd1;
            cnt <= 3'd0; // Reset counter to 0
        end else begin
            // Shift parallel output data and add new serial input data bit
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'd1; // Increment counter
            dout_valid <= 1'd0; // Reset output valid signal to 0
        end
    end else begin
        cnt <= 3'd0; // Reset counter to 0
        dout_valid <= 1'd0; // Reset output valid signal to 0
    end
end

endmodule