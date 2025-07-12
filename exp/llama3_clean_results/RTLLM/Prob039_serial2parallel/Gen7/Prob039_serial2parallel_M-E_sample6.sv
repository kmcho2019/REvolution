module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg; // 8-bit shift register to store incoming serial data
reg [2:0] cnt; // 3-bit counter to keep track of the number of bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, shift register, and output when the reset signal is low
        cnt <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 3'b1000) begin
            // Shift in the new data
            shift_reg <= {din_serial, shift_reg[7:1]};
            // Increment the counter
            cnt <= cnt + 1'b1;
            // Set the output valid signal to 0
            dout_valid <= 1'b0;
        end else begin
            // If the counter is 8, assign the shift register's contents to the parallel output and set the output valid signal to 1
            dout_parallel <= shift_reg;
            dout_valid <= 1'b1;
            // Reset the counter and shift register
            cnt <= 3'b000;
            shift_reg <= 8'b00000000;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        shift_reg <= shift_reg;
        // Set the output valid signal to 0 if the counter is not 8
        if (cnt == 3'b1000) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule