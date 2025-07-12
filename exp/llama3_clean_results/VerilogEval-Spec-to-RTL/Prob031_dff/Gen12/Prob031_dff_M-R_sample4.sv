module TopModule(
    input clk,
    input d,
    output reg q
);

// Directly use a reg for the output and update it based on the clock edge
reg q_reg;

// Utilize a non-blocking assignment within an always block to update the output
always @(posedge clk)
    q_reg <= d;

// Assign the output of the flip-flop directly to the output port
assign q = q_reg;

endmodule