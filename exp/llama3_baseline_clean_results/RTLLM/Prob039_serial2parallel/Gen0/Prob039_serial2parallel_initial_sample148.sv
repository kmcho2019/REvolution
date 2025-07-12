module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output reg [7:0] dout_parallel, 
    output reg dout_valid
);

reg [2:0] cnt; // Counter to track the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        cnt <= 3'd0; // Initialize counter to 0
        dout_valid <= 1'b0; // Reset dout_valid to 0
        dout_parallel <= 8'd0; // Reset dout_parallel to 0
    end else if (din_valid) begin // If input data is valid
        if (cnt == 3'd7) begin // If all 8 serial data bits have been received
            dout_parallel <= {din_serial, dout_parallel[7:1]}; // Output the parallel data
            dout_valid <= 1'b1; // Set dout_valid to 1
            cnt <= 3'd0; // Reset counter to 0
        end else begin
            dout_parallel <= {din_serial, dout_parallel[7:1]}; // Shift in the serial input data
            cnt <= cnt + 1'b1; // Increment counter
            dout_valid <= 1'b0; // Set dout_valid to 0
        end
    end else begin
        cnt <= cnt; // Keep counter unchanged
        dout_valid <= 1'b0; // Keep dout_valid unchanged
        dout_parallel <= dout_parallel; // Keep dout_parallel unchanged
    end
end

endmodule