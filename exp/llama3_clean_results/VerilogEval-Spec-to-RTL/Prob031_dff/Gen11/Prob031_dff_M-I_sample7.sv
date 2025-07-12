module TopModule(
    input clk,
    input d,
    output reg q
);

// Explicitly declare the output as a reg to ensure it's inferred as a flip-flop
reg q_reg;

// Use a non-blocking assignment to update the flip-flop's state on the positive edge of the clock
always @(posedge clk)
    q_reg <= d;

// Continuously assign the output of the flip-flop to the output port
assign q = q_reg;

endmodule