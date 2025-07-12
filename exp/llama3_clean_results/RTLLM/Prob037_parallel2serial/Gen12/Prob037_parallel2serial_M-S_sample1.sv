module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] shift_reg;             // Shift register to store parallel input data

// Assign valid signal based on shift register value
assign valid_out = (shift_reg != 4'b0000) ? 1 : 0;  

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset shift register
        shift_reg <= 4'b0000;
    end else if (shift_reg == 4'b0000) begin
        // Load parallel input data into shift register
        shift_reg <= d;
    end else begin
        // Shift shift register one bit to the right
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

// Assign most significant bit of shift register to serial output
assign dout = shift_reg[3];

endmodule