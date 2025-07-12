module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg; // 8-bit shift register
reg [2:0] cnt; // 3-bit counter to count the number of bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register, counter, and output valid signal
        shift_reg <= 8'b00000000;
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new serial data and increment the counter
        shift_reg <= {shift_reg[6:0], din_serial};
        cnt <= cnt + 1'b1;
        
        // Check if the shift register is full (8 bits received)
        if (cnt == 3'b111) begin
            // Update the parallel output and set the output valid signal to 1
            dout_parallel <= shift_reg;
            dout_valid <= 1'b1;
            // Reset the counter and shift register for the next set of data
            cnt <= 3'b000;
            shift_reg <= 8'b00000000;
        end else begin
            // If the shift register is not full, set the output valid signal to 0
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input is not valid, do not update the shift register or counter
        shift_reg <= shift_reg;
        cnt <= cnt;
        dout_valid <= 1'b0;
    end
end

endmodule