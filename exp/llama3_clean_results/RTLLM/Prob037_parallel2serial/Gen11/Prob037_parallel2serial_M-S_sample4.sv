module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data;                  // Internal data register

// Sequential logic for counter and data register
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register on reset
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and update data register
        cnt <= 2'b00;
        data <= d;
    end else begin
        // Otherwise, increment counter
        cnt <= cnt + 1'b1;
    end
end

// Assign valid signal based on counter value
assign valid_out = (cnt == 2'b00);   

// Assign bit from data register based on counter
assign dout = data[3 - cnt];

endmodule