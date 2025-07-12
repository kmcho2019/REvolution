module serial2parallel(
    input  clk,        // Clock signal
    input  rst_n,      // Reset signal (active low)
    input  din_serial, // Serial input data
    input  din_valid,  // Validity signal for input data
    output [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output dout_valid  // Validity signal for the output data
);

reg [7:0] data_reg; // Internal 8-bit register to store received serial data
reg [3:0] cnt;      // 4-bit counter to track the number of serial input data bits
reg       dout_valid_reg; // Internal register for dout_valid signal

// Initialize the counter and internal register on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        data_reg <= 8'd0;
        dout_valid_reg <= 1'b0;
    end else begin
        if (din_valid) begin
            // Shift the internal register one bit to the left and add the new serial input data
            data_reg <= {data_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end

        // Update the output when the counter reaches 8
        if (cnt == 4'd8) begin
            dout_parallel <= data_reg;
            dout_valid_reg <= 1'b1;
            cnt <= 4'd0;
            data_reg <= 8'd0;
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end
end

// Continuous assignment for output signals
assign dout_parallel = data_reg;
assign dout_valid = dout_valid_reg;

endmodule