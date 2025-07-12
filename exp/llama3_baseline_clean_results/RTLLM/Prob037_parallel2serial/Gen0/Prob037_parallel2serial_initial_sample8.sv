module parallel2serial (
    input         clk,        // Clock signal
    input         rst_n,      // Reset signal (active low)
    input  [3:0]  d,          // 4-bit parallel data input
    output        valid_out,  // Valid signal indicating availability of serial output
    output        dout        // Serial output representing the converted data
);

reg [3:0] data;  // Data register to store the input data
reg [1:0] cnt;   // Counter register to keep track of the number of bits output
reg         valid;  // Valid signal (internal)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        data <= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin  // Last bit of the parallel input
            data <= d;  // Update the data register with the parallel input
            cnt <= 2'b00;  // Reset the counter
            valid <= 1'b1;  // Set the valid signal to 1
        end else begin
            cnt <= cnt + 1'b1;  // Increment the counter
            valid <= 1'b0;  // Reset the valid signal
            data <= {data[2:0], 1'b0};  // Shift the data register one bit to the right
        end
    end
end

assign valid_out = valid;  // Assign the internal valid signal to the output
assign dout = data[3];  // Assign the MSB of the data register to the serial output

endmodule