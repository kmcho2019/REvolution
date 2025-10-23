module parallel2serial (
    input         clk,        // Clock signal
    input         rst_n,      // Reset signal (active low)
    input  [3:0]  d,          // 4-bit parallel data input
    output        valid_out, // Valid signal indicating the availability of serial output
    output        dout       // Serial output representing the converted data
);

reg [3:0] data;  // Internal register to store the input data
reg [1:0] cnt;  // Counter to control the output of each bit
reg         valid;  // Internal valid signal

assign valid_out = valid;  // Assign the internal valid signal to the output
assign dout = data[3];    // Assign the most significant bit of the internal register to the output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        data <= 4'b0;  // Reset the internal register
        cnt <= 2'b0;   // Reset the counter
        valid <= 1'b0; // Reset the valid signal
    end else begin
        if (cnt == 2'b11) begin  // If the counter is at its maximum value
            data <= d;          // Update the internal register with the new input data
            cnt <= 2'b0;         // Reset the counter
            valid <= 1'b1;       // Set the valid signal to 1
        end else begin
            cnt <= cnt + 1'b1;   // Increment the counter
            valid <= 1'b0;       // Reset the valid signal
            data <= {data[2:0], 1'b0};  // Shift the internal register one bit to the right
        end
    end
end

endmodule