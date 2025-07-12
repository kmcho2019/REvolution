module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter

// Assign valid signal based on counter value
assign valid_out = (cnt == 2'b00);   

// Assign bit from input data based on counter
assign dout = d[3 - cnt];

// Sequential logic for counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter on reset
        cnt <= 2'b00;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter
        cnt <= 2'b00;
    end else begin
        // Otherwise, increment counter
        cnt <= cnt + 1'b1;
    end
end

endmodule