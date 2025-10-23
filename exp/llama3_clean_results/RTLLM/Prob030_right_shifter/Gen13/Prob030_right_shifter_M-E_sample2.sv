module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'd0;  // Initialize q to 0
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
end

// Alternatively, to illustrate the circular shift register concept:
// reg [7:0] shift_reg;
// initial shift_reg = 8'd0;
// always @(posedge clk) begin
//     shift_reg <= {d, shift_reg[7:1]};  // Circular shift register with feedback
//     q <= shift_reg;
// end

endmodule