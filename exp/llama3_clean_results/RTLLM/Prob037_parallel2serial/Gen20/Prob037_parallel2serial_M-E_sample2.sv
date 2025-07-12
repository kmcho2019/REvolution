module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] shift_reg;              // 4-bit shift register
reg [1:0] cnt;                    // 2-bit counter

// Sequential logic for counter and shift register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and shift register on reset
        cnt <= 2'b00;
        shift_reg <= 4'b0000;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and load shift register with input data
        cnt <= 2'b00;
        shift_reg <= d;
    end else begin
        // Otherwise, increment counter and shift shift register
        cnt <= cnt + 1'b1;
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

// Assign valid signal and output
assign valid_out = (cnt == 2'b00);
assign dout = shift_reg[3];

endmodule