module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data;                  // Shift register for parallel data
reg [1:0] cnt;                   // Counter to keep track of the bits
reg        valid;                 // Valid signal indicating availability of serial output

// Assign valid signal based on counter value
assign valid_out = valid;

// Assign most significant bit of data to output
assign dout = data[3];

always @ (posedge clk) begin
    if (~rst_n) begin
        // Reset data, counter, and valid signal
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and load new data
        cnt <= 2'b00;
        data <= d;
        valid <= 1'b1;
    end else if (valid) begin
        // If valid signal is high, shift data and increment counter
        data <= {data[2:0], 1'b0};
        cnt <= cnt + 1;
        if (cnt == 2'b11) begin
            valid <= 1'b0;
        end
    end
end

endmodule