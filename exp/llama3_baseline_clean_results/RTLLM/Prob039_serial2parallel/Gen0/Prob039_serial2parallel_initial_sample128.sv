module serial2parallel(
    input           clk,       // Clock signal
    input           rst_n,     // Reset signal (active low)
    input           din_serial, // Serial input data
    input           din_valid, // Validity signal for input data
    output [7:0]    dout_parallel, // Parallel output data (8 bits wide)
    output          dout_valid  // Validity signal for the output data
);

reg [7:0] dout_parallel_reg; // Register to store the parallel output data
reg [2:0] cnt_reg;           // 3-bit counter to track the number of serial input data bits
reg       dout_valid_reg;   // Register to store the validity signal for the output data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers
        dout_parallel_reg <= 8'd0;
        cnt_reg <= 3'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin
        // Shift the serial input data into the parallel output register
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        
        // Increment the counter
        cnt_reg <= cnt_reg + 1'd1;
        
        // If all 8 bits have been received, set the validity signal and reset the counter
        if (cnt_reg == 3'd7) begin
            dout_valid_reg <= 1'd1;
            cnt_reg <= 3'd0;
        end else begin
            dout_valid_reg <= 1'd0;
        end
    end else begin
        // If the input data is not valid, reset the counter and validity signal
        cnt_reg <= 3'd0;
        dout_valid_reg <= 1'd0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule