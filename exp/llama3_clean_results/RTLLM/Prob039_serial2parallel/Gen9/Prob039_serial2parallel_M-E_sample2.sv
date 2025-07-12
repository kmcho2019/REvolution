module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_register; // 8-bit shift register to store incoming serial data bits
reg [2:0] counter; // 3-bit counter to keep track of the number of bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register, counter, and output when the reset signal is low
        shift_register <= 8'b00000000;
        counter <= 3'b000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the incoming serial data bit
        shift_register <= {din_serial, shift_register[7:1]};
        // Increment the counter
        counter <= counter + 1'b1;
        // Check if 8 bits have been received
        if (counter == 3'b111) begin
            // Set the parallel output and valid signal
            dout_parallel <= shift_register;
            dout_valid <= 1'b1;
            // Reset the counter and shift register
            counter <= 3'b000;
            shift_register <= 8'b00000000;
        end else begin
            // Set the output valid signal to 0 if less than 8 bits have been received
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input is not valid, do not update the shift register or counter
        shift_register <= shift_register;
        counter <= counter;
        // Set the output valid signal to 0 if less than 8 bits have been received
        if (counter == 3'b111) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule