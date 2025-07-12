module serial2parallel(
    input  clk,            // Clock signal
    input  rst_n,           // Reset signal (active low)
    input  din_serial,      // Serial input data
    input  din_valid,       // Validity signal for input data
    output [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output dout_valid       // Validity signal for the output data
);

reg [7:0] dout_parallel_reg;  // Internal register for parallel output data
reg [3:0] cnt;                // 4-bit counter to keep track of the number of serial input data bits received
reg dout_valid_reg;           // Internal register for validity signal of output data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers to their initial values
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else begin
        if (din_valid) begin
            // Shift the received serial bit to the MSB of the parallel output data
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            // Increment the counter
            cnt <= cnt + 1;
            // If all 8 serial data bits have been received, set the validity signal to 1
            if (cnt == 4'd8) begin
                dout_valid_reg <= 1'd1;
            end else begin
                dout_valid_reg <= 1'd0;
            end
            // If all 8 serial data bits have been received, reset the counter
            if (cnt == 4'd8) begin
                cnt <= 4'd0;
            end
        end else begin
            // If the input data is not valid, reset the counter and the validity signal
            cnt <= 4'd0;
            dout_valid_reg <= 1'd0;
        end
    end
end

// Continuous assignments for output signals
assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule