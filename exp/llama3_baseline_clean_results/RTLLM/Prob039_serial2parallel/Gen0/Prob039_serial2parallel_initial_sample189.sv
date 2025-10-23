module serial2parallel(
    input clk, // Clock signal
    input rst_n, // Reset signal (active low)
    input din_serial, // Serial input data
    input din_valid, // Validity signal for input data
    output [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output dout_valid // Validity signal for the output data
);

reg [7:0] dout_parallel_reg; // Register for parallel output data
reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received
reg dout_valid_reg; // Register for valid output signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        dout_parallel_reg <= 8'b0; // Reset parallel output data to 0
        cnt <= 4'b0; // Reset counter to 0
        dout_valid_reg <= 1'b0; // Reset valid output signal to 0
    end else if (din_valid) begin // If input data is valid
        if (cnt == 4'b1000) begin // If all 8 serial data bits have been received
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial}; // Shift serial input data into parallel output register
            cnt <= 4'b0; // Reset counter to 0
            dout_valid_reg <= 1'b1; // Set valid output signal to 1
        end else begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial}; // Shift serial input data into parallel output register
            cnt <= cnt + 1'b1; // Increment counter
            dout_valid_reg <= 1'b0; // Set valid output signal to 0
        end
    end else begin
        cnt <= cnt; // Keep counter unchanged if input data is not valid
        dout_valid_reg <= 1'b0; // Set valid output signal to 0 if input data is not valid
    end
end

assign dout_parallel = dout_parallel_reg; // Assign parallel output data to output port
assign dout_valid = dout_valid_reg; // Assign valid output signal to output port

endmodule