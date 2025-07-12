module serial2parallel(
    input clk,         // Clock signal
    input rst_n,       // Reset signal (active low)
    input din_serial,  // Serial input data
    input din_valid,   // Validity signal for input data
    output reg [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output reg dout_valid  // Validity signal for the output data
);

reg [3:0] cnt;  // 4-bit counter to keep track of the number of serial input data bits received
reg [7:0] shift_reg;  // 8-bit shift register to store the serial input data bits

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the circuit to its initial state
        cnt <= 4'b0;
        shift_reg <= 8'b0;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift the serial input data into the shift register
        shift_reg <= {shift_reg[6:0], din_serial};
        
        // Increment the counter
        cnt <= cnt + 1'b1;
        
        // Check if all 8 serial data bits have been received
        if (cnt == 4'b1000) begin
            // Assign the parallel output data
            dout_parallel <= shift_reg;
            
            // Set the dout_valid signal to 1
            dout_valid <= 1'b1;
            
            // Reset the counter and the shift register
            cnt <= 4'b0;
            shift_reg <= 8'b0;
        end else begin
            // Reset the dout_valid signal to 0
            dout_valid <= 1'b0;
        end
    end else begin
        // Reset the dout_valid signal to 0 if din_valid is 0
        dout_valid <= 1'b0;
    end
end

endmodule