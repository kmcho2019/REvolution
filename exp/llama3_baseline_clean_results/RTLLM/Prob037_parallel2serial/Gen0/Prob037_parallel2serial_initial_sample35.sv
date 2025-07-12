module parallel2serial (
    input  clk,        // Clock signal
    input  rst_n,       // Reset signal
    input  [3:0] d,     // 4-bit parallel data input
    output reg  valid_out, // Valid signal indicating the availability of serial output
    output reg  dout      // Serial output representing the converted data
);

reg [3:0] data;         // Data register
reg [1:0] cnt;          // Counter register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin       // Reset
        cnt <= 0;
        valid_out <= 0;
        data <= 0;
    end else begin
        if (cnt == 3) begin // Last bit of parallel input
            data <= d;      // Update data register with parallel input
            cnt <= 0;       // Reset counter
            valid_out <= 1; // Set valid signal
        end else begin
            cnt <= cnt + 1; // Increment counter
            valid_out <= 0;  // Reset valid signal
            data <= data >> 1; // Shift data register one bit to the right
        end
    end
end

always @ (*) begin
    dout = data[3];        // Assign most significant bit of data register to serial output
end

endmodule