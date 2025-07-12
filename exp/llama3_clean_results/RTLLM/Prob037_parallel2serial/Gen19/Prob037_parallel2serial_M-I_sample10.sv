module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg        clk_en;               // Clock enable for counter

// Sequential logic for counter and clock enable
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and clock enable on reset
        cnt <= 2'b00;
        clk_en <= 1'b0;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and clock enable
        cnt <= 2'b00;
        clk_en <= 1'b0;
    end else begin
        // Otherwise, set clock enable to increment counter
        clk_en <= 1'b1;
        cnt <= cnt + 1'b1;
    end
end

// Assign valid signal based on counter value
assign valid_out = (cnt == 2'b00);   

// Assign bit from input data based on counter
assign dout = d[3 - cnt];

endmodule