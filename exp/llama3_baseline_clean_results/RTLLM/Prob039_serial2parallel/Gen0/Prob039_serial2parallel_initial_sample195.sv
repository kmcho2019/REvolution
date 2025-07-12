module serial2parallel(
    input clk,            // Clock signal
    input rst_n,          // Reset signal (active low)
    input din_serial,     // Serial input data
    input din_valid,      // Validity signal for input data
    output [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output dout_valid     // Validity signal for the output data
);

reg [3:0] cnt;            // 4-bit counter to track the number of serial input data bits
reg [7:0] dout_parallel_reg;  // Register to hold the parallel output data
reg dout_valid_reg;      // Register to hold the validity signal for the output data

// Initialize the output signals
assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

// Synchronous design, operating on the rising edge of the clock signal
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output signals
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        // Shift the serial input data into the parallel output register
        case (cnt)
            4'b0000: dout_parallel_reg[7] <= din_serial;
            4'b0001: dout_parallel_reg[6] <= din_serial;
            4'b0010: dout_parallel_reg[5] <= din_serial;
            4'b0011: dout_parallel_reg[4] <= din_serial;
            4'b0100: dout_parallel_reg[3] <= din_serial;
            4'b0101: dout_parallel_reg[2] <= din_serial;
            4'b0110: dout_parallel_reg[1] <= din_serial;
            4'b0111: dout_parallel_reg[0] <= din_serial;
        endcase
        
        // Increment the counter
        if (cnt == 4'b0111) begin
            cnt <= 4'b0000;
            dout_valid_reg <= 1'b1;  // Set the validity signal to 1
        end else begin
            cnt <= cnt + 1;
            dout_valid_reg <= 1'b0;  // Set the validity signal to 0
        end
    end else begin
        // If the input data is not valid, reset the counter and output signals
        cnt <= 4'b0000;
        dout_valid_reg <= 1'b0;
    end
end

endmodule