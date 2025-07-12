module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

// Combinational logic to calculate the next state
wire [7:0] next_q;
assign next_q = {d, q_reg[7:1]};

// Sequential logic to update the register
always @(posedge clk) begin
    q_reg <= next_q;
end

// Directly using the reg for output
assign q = q_reg;

endmodule