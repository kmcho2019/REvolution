module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register to hold the input data

assign valid_out = (cnt == 0) ? 1 : 0;  // Valid signal is high when counter is 0
assign dout = data[3];                   // Output is the most significant bit of data

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 3) begin
        // Load new data when counter reaches 3
        cnt <= 2'b00;
        data <= d;
    end else begin
        // Increment counter and shift data
        cnt <= cnt + 1;
        data <= {data[2:0], 1'b0}; // Shift data one bit to the right
    end
end

endmodule