module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received
reg [7:0] shift_reg; // Shift register to hold the incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, shift register, and output when the reset signal is low
        cnt <= 4'b0000;
        shift_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data
            shift_reg <= {din_serial, shift_reg[7:1]};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter and set the output valid signal to 1
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end
        // Set the output valid signal to 0 when the counter is not 8
        if (cnt!= 4'b1000) begin
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        shift_reg <= shift_reg;
        // Set the output valid signal to 0
        dout_valid <= 1'b0;
    end
end

// Use assign to drive the output dout_parallel
assign dout_parallel = (cnt == 4'b1000)? shift_reg : 8'b00000000;

endmodule