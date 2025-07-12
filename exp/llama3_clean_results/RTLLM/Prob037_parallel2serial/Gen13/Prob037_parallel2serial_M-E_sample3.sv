module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] shift_reg;             // Shift register to hold input data
reg        valid;                // Valid signal indicating availability of serial output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 4'b0000;     // Reset shift register
        valid     <= 1'b0;        // Reset valid signal
    end else if (valid == 1'b0) begin
        shift_reg <= d;           // Load input data into shift register
        valid     <= 1'b1;         // Set valid signal
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b0}; // Shift register contents one bit to the right
        valid     <= (shift_reg != 4'b0000) ? 1'b1 : 1'b0; // Update valid signal
    end
end

assign dout    = shift_reg[3];   // Assign most significant bit of shift register as serial output
assign valid_out = valid;        // Assign valid signal to output

endmodule