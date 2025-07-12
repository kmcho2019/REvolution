module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data;                  // Register to store the parallel input
reg [1:0] cnt;                   // Counter to keep track of the bits

// Assign valid signal based on counter value
assign valid_out = (cnt != 0) ? 1 : 0;  

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 0) begin
        // Load parallel input into data register
        data <= d;
        cnt <= 2'b11;  // Start outputting bits
    end else begin
        // Decrement counter and shift data register
        cnt <= cnt - 1;
    end
end

// Assign most significant bit of data register to serial output
assign dout = data[3];

endmodule