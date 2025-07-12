module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;  // counter to track the current bit being output
reg [3:0] data;  // data register to store the current parallel input
reg valid;  // valid signal to indicate the availability of valid serial output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter, data register, and valid signal on reset
        cnt <= 2'b00;
        data <= 4'b0000;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'd3) begin
            // Update the data register with the new parallel input, reset the counter, and set the valid signal to 1
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin
            // Increment the counter, set the valid signal to 0, and shift the data register one bit to the right
            cnt <= cnt + 1;
            valid <= 1'b0;
        end
    end
end

assign dout = data[3];  // Assign the most significant bit of the data register to the serial output
assign valid_out = (cnt == 2'd0) && valid;  // Assign the valid signal to the output valid_out when cnt is 0

endmodule