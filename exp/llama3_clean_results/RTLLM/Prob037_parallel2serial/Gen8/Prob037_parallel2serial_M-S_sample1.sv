module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter
        cnt <= 2'b00;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, reset counter
            cnt <= 2'b00;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
        end
    end
end

// Assign corresponding bit of parallel input to serial output based on counter value
assign dout = (cnt == 0) ? d[3] : 
              (cnt == 1) ? d[2] : 
              (cnt == 2) ? d[1] : 
              (cnt == 3) ? d[0] : 1'b0;

endmodule