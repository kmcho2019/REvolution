module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter to track the number of serial input data bits received

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin  // If input data is valid
        if (cnt < 4'd8) begin  // If less than 8 bits have been received
            dout_parallel <= {dout_parallel[6:0], din_serial};  // Shift the bits to the left and add the new bit
            cnt <= cnt + 1'b1;  // Increment the counter
            dout_valid <= 1'b0;  // Set the valid output signal to 0
        end else begin  // If 8 bits have been received
            cnt <= 4'd0;  // Reset the counter
            dout_valid <= 1'b1;  // Set the valid output signal to 1
        end
    end else begin  // If input data is not valid
        cnt <= cnt;  // Keep the counter value
        dout_parallel <= dout_parallel;  // Keep the parallel output value
        dout_valid <= 1'b0;  // Set the valid output signal to 0
    end
end

endmodule