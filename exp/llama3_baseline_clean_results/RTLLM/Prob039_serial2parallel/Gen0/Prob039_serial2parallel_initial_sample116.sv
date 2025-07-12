module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output [7:0] dout_parallel, 
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [3:0] cnt;
reg dout_valid_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers
        cnt <= 4'b0;
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        // Shift serial input into parallel output
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        cnt <= cnt + 1;
        
        // Check if all 8 bits have been received
        if (cnt == 4'd8) begin
            // Set valid output signal
            dout_valid_reg <= 1'b1;
            // Reset counter
            cnt <= 4'b0;
        end else begin
            // Clear valid output signal
            dout_valid_reg <= 1'b0;
        end
    end else begin
        // Reset valid output signal if no valid input
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule