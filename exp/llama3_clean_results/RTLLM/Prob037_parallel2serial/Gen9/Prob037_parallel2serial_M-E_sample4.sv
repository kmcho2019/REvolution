module parallel2serial_shiftreg (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] shift_reg;              // 4-bit shift register
reg [1:0] cnt;                    // Internal counter

assign valid_out = (cnt != 0);    // Assign valid signal based on counter value
assign dout = shift_reg[3];       // Assign most significant bit of shift register as output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset shift register and counter
        shift_reg <= 4'b0000;
        cnt <= 2'b00;
    end else if (cnt == 2'b00) begin
        // Load shift register with input data and set counter
        shift_reg <= d;
        cnt <= 2'b11;
    end else begin
        // Shift shift register and decrement counter
        shift_reg <= {shift_reg[2:0], 1'b0};
        cnt <= cnt - 1'b1;
    end
end

endmodule