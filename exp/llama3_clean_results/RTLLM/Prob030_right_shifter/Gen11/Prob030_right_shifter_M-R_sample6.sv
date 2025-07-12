module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

// Use assign statement to define the combinational logic for the next state
wire [7:0] next_q;
assign next_q = {d, q_reg[7:1]};

// Use always block to update the register value synchronously with the clock
always @(posedge clk) begin
    q_reg <= next_q;
end

// Assign the register output to the module output
assign q = q_reg;

endmodule