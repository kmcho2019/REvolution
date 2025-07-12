module serial2parallel(
    input clk,            // Clock signal
    input rst_n,          // Reset signal (active low)
    input din_serial,     // Serial input data
    input din_valid,      // Validity signal for input data
    output [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output dout_valid      // Validity signal for the output data
);

reg [7:0] dout_parallel_reg;  // Register to store the parallel output data
reg [3:0] cnt;               // 4-bit counter to keep track of the number of serial input data bits received
reg dout_valid_reg;          // Register to store the validity signal for the output data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the output data when the reset signal is low
        cnt <= 4'b0;
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        // Shift the serial input data into the parallel output data register
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        // Increment the counter for each valid input data
        cnt <= cnt + 1'b1;
        if (cnt == 4'd7) begin
            // Set the valid output signal to 1 when 8 serial data bits have been received
            dout_valid_reg <= 1'b1;
            cnt <= 4'b0;  // Reset the counter
        end else begin
            // Reset the valid output signal to 0 when the counter is not 8
            dout_valid_reg <= 1'b0;
        end
    end else begin
        // Reset the valid output signal to 0 when the input data is not valid
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;  // Assign the parallel output data register to the output port
assign dout_valid = dout_valid_reg;        // Assign the validity signal register to the output port

endmodule