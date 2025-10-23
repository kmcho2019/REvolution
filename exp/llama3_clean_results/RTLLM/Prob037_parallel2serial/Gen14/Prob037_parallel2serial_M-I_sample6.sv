module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Register to hold the input data

// Assign valid signal based on counter value
assign valid_out = (cnt == 0)? 1 : 0;  
// Assign most significant bit of data to output based on counter
assign dout = data[3 - cnt];          

always @ (posedge clk) begin
    if (!rst_n) begin
        // Synchronous reset
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 3) begin
        // If counter has reached 3, reset counter and update data
        cnt <= 2'b00;
        data <= d;
    end else if (cnt == 0) begin
        // Update data when counter is 0
        data <= d;
        cnt <= cnt + 1;
    end else begin
        // Otherwise, increment counter
        cnt <= cnt + 1;
    end
end

endmodule