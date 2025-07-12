module serial2parallel(
    input           clk,            // Clock signal
    input           rst_n,          // Reset signal (active low)
    input           din_serial,     // Serial input data
    input           din_valid,     // Validity signal for input data
    output reg [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output reg      dout_valid     // Validity signal for the output data
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt           <= 4'b0000; // Reset counter to 0
        dout_parallel <= 8'b00000000; // Reset parallel output to 0
        dout_valid    <= 1'b0; // Reset valid output signal to 0
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin // All 8 serial data bits have been received
            cnt           <= 4'b0000; // Reset counter to 0
            dout_parallel <= {dout_parallel[6:0], din_serial}; // Output parallel data
            dout_valid    <= 1'b1; // Set valid output signal to 1
        end else begin
            cnt           <= cnt + 1; // Increment counter
            dout_parallel <= {dout_parallel[6:0], din_serial}; // Shift parallel output data
            dout_valid    <= 1'b0; // Reset valid output signal to 0
        end
    end else begin
        cnt           <= cnt; // Hold counter value
        dout_parallel <= dout_parallel; // Hold parallel output data
        dout_valid    <= 1'b0; // Reset valid output signal to 0
    end
end

endmodule