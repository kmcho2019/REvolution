module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output reg [7:0] dout_parallel, 
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;  // Reset counter when reset signal is low
        dout_parallel <= 8'd0;  // Reset dout_parallel when reset signal is low
        dout_valid <= 1'b0;  // Reset dout_valid when reset signal is low
    end else if (din_valid) begin
        if (cnt == 4'd7) begin
            cnt <= 4'd0;  // Reset counter when 8 bits have been received
            dout_valid <= 1'b1;  // Set dout_valid to 1 when 8 bits have been received
        end else begin
            cnt <= cnt + 1'b1;  // Increment counter for each valid din_serial
            dout_valid <= 1'b0;  // Set dout_valid to 0 until 8 bits have been received
        end
        // Build dout_parallel by shifting in the new din_serial bit
        dout_parallel <= {dout_parallel[6:0], din_serial};  
    end else begin
        cnt <= cnt;  // Hold counter value when din_valid is 0
        dout_parallel <= dout_parallel;  // Hold dout_parallel value when din_valid is 0
        dout_valid <= 1'b0;  // Set dout_valid to 0 when no valid din_serial
    end
end

endmodule