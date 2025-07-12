module serial2parallel(
    input  clk,        // Clock signal
    input  rst_n,      // Reset signal (active low)
    input  din_serial, // Serial input data
    input  din_valid,  // Validity signal for input data
    output [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output dout_valid  // Validity signal for the output data
);

reg [7:0] dout_parallel_reg;
reg       dout_valid_reg;
reg [3:0] cnt; // 4-bit counter to keep track of received bits

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers
        dout_parallel_reg <= 8'b0;
        dout_valid_reg     <= 1'b0;
        cnt                <= 4'b0;
    end else if (din_valid) begin
        // Shift in the new bit and increment the counter
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        cnt                <= cnt + 1'b1;

        // If 8 bits have been received, set dout_valid to 1
        if (cnt == 4'b1000) begin
            dout_valid_reg <= 1'b1;
        end else begin
            dout_valid_reg <= 1'b0;
        end

        // If 8 bits have been received, reset the counter
        if (cnt == 4'b1000) begin
            cnt <= 4'b0;
        end
    end else begin
        // If the input is not valid, do not change the output
        dout_valid_reg <= 1'b0;
    end
end

// Continuous assignments for output
assign dout_parallel = dout_parallel_reg;
assign dout_valid    = dout_valid_reg;

endmodule