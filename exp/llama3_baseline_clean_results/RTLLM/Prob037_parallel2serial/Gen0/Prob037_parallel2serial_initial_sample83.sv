module parallel2serial (
    input   clk,       // Clock signal
    input   rst_n,     // Reset signal (active low)
    input   [3:0] d,   // 4-bit parallel data input
    output  valid_out, // Valid signal indicating the availability of serial output
    output  dout       // Serial output representing the converted data
);

reg [3:0] data; // Data register to hold the parallel input
reg [1:0] cnt;  // Counter to keep track of the current bit being output
reg valid;      // Valid signal to indicate when the serial output is valid

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 2'd0;  // Reset counter to 0
        valid <= 1'b0; // Reset valid signal to 0
        data <= 4'd0;  // Reset data register to 0
    end else begin
        if (cnt == 2'd3) begin // Last bit of parallel input
            cnt <= 2'd0;  // Reset counter to 0 for next conversion
            data <= d;    // Update data register with new parallel input
            valid <= 1'b1; // Set valid signal to indicate availability of serial output
        end else begin
            cnt <= cnt + 1; // Increment counter for next bit
            valid <= 1'b0;  // Reset valid signal
            data <= {data[2:0], data[3]}; // Shift data register one bit to the left
        end
    end
end

always @ (*) begin
    if (valid) begin
        dout = data[3]; // Assign most significant bit of data to serial output when valid
    end else begin
        dout = 1'b0; // Default serial output to 0 when not valid
    end
    valid_out = valid; // Assign valid signal to output
end

endmodule