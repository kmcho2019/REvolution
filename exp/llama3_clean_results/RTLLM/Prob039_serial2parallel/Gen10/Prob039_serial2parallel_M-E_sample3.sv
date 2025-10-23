module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg; // 8-bit shift register to store incoming serial data
reg [3:0] cnt; // 4-bit counter to track the number of bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register, counter, and output valid signal
        shift_reg <= 8'b00000000;
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
        dout_parallel <= 8'b00000000;
    end else if (din_valid) begin
        // Shift in the new serial data and increment the counter
        shift_reg <= {shift_reg[6:0], din_serial};
        cnt <= cnt + 1'b1;
        
        // If the counter reaches 8, update the parallel output data and assert the valid output signal
        if (cnt == 4'b1000) begin
            dout_parallel <= shift_reg;
            dout_valid <= 1'b1;
            cnt <= 4'b0000; // Reset the counter
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input data is not valid, do not update the shift register or counter
        shift_reg <= shift_reg;
        cnt <= cnt;
        dout_valid <= 1'b0;
    end
end

endmodule