module serial2parallel(
    input clk,            // Clock signal
    input rst_n,          // Reset signal (active low)
    input din_serial,     // Serial input data
    input din_valid,      // Validity signal for input data
    output [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output dout_valid      // Validity signal for the output data
);

reg [3:0] cnt;            // 4-bit counter
reg [7:0] data_reg;       // Register to store the incoming serial data bits

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the output register
        cnt <= 4'b0000;
        data_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift the incoming serial data bits into the register
        data_reg <= {din_serial, data_reg[7:1]};
        cnt <= cnt + 1'b1;
        
        if (cnt == 4'b1000) begin
            // Output the 8-bit parallel data and set the dout_valid signal to 1
            dout_parallel <= data_reg;
            dout_valid <= 1'b1;
            cnt <= 4'b0000;
        end else begin
            // The parallel output data is not valid yet
            dout_valid <= 1'b0;
        end
    end else begin
        // No valid input data, do not update the counter or the output register
        cnt <= cnt;
        data_reg <= data_reg;
        dout_valid <= 1'b0;
    end
end

endmodule