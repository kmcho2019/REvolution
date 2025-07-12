module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal shift register to store parallel input data
reg [3:0] shift_reg;

// Clock gate signal to control clocking of shift register
reg clk_gate;

// Assign valid signal based on shift register value
assign valid_out = (shift_reg!= 4'b0)? 1 : 0;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset shift register and clock gate
        shift_reg <= 4'b0;
        clk_gate  <= 1'b0;
    end else begin
        if (~clk_gate) begin
            // Load parallel input data into shift register and set clock gate
            shift_reg <= d;
            clk_gate  <= 1'b1;
        end else if (shift_reg == 4'b1) begin
            // If shift register has reached the end, reset clock gate
            clk_gate  <= 1'b0;
        end
    end
end

// Clock gated shift register
always @ (posedge clk) begin
    if (clk_gate) begin
        // Shift out the most significant bit of the shift register
        shift_reg <= {1'b0, shift_reg[3:1]};
    end
end

// Assign serial output from shift register
assign dout = shift_reg[0];

endmodule