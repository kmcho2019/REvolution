module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

// Initialize q_reg to 0
initial q_reg = 8'b0;

// Combinational logic to calculate the next state
wire [7:0] next_q;
assign next_q = (q_reg >> 1) | (d << 7);

// Sequential logic to update the register
always @(posedge clk) begin
    q_reg <= next_q;
end

// Directly using the reg for output
assign q = q_reg;

endmodule