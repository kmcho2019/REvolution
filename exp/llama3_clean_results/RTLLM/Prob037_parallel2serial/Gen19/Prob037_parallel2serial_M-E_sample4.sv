module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] buffer;                 // Circular buffer to store parallel input data
reg [1:0] cnt;                    // Counter to keep track of the current position in the buffer
reg        load;                  // Load signal to load new parallel input data into the buffer

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter, buffer, and load signal
        cnt <= 2'b00;
        buffer <= 4'b0000;
        load <= 1'b0;
    end else begin
        if (cnt == 3) begin
            // If counter has reached the end of the buffer, wrap around to the beginning
            cnt <= 2'b00;
            load <= 1'b1;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
            load <= 1'b0;
        end
        
        // Load new parallel input data into the buffer when load signal is asserted
        if (load) begin
            buffer <= d;
        end
    end
end

// Assign corresponding bit of buffer to serial output based on counter value
assign dout = buffer[3 - cnt];

endmodule