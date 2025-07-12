module serial2parallel (
    input  logic clk,           // Clock signal
    input  logic rst_n,         // Reset signal (active low)
    input  logic din_serial,    // Serial input data
    input  logic din_valid,    // Validity signal for input data
    output logic [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output logic dout_valid     // Validity signal for the output data
);

    logic [3:0] cnt;            // 4-bit counter to keep track of the number of serial input data bits received
    logic [7:0] dout_parallel_reg;  // Register to hold the parallel output data

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 4'd0;        // Reset the counter
            dout_parallel_reg <= 8'd0;  // Reset the parallel output data register
            dout_valid <= 1'd0;  // Reset the valid output signal
        end else if (din_valid) begin
            if (cnt == 4'd7) begin
                // If 8 serial data bits have been received, output the parallel data and set the valid output signal to 1
                dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};  // Shift the parallel output data register to the left and add the new serial input data
                cnt <= 4'd0;        // Reset the counter
                dout_valid <= 1'd1;  // Set the valid output signal to 1
            end else begin
                // If less than 8 serial data bits have been received, shift the parallel output data register to the left and add the new serial input data
                dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};  // Shift the parallel output data register to the left and add the new serial input data
                cnt <= cnt + 1'd1;   // Increment the counter
                dout_valid <= 1'd0;  // Set the valid output signal to 0
            end
        end else begin
            // If the input data is not valid, do not change the counter or the parallel output data register
            cnt <= cnt;
            dout_parallel_reg <= dout_parallel_reg;
            dout_valid <= 1'd0;  // Set the valid output signal to 0
        end
    end

    assign dout_parallel = dout_parallel_reg;  // Assign the parallel output data register to the output

endmodule