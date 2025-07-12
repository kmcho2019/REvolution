module TopModule(
    input  clk,
    input  x,
    output z
);

reg q_xnor, q_and, q_or;
wire xnor_in, and_in, or_in;

// Define the inputs to the gates
assign xnor_in = x ^ q_xnor;
assign and_in = x & ~q_and;
assign or_in = x | ~q_or;

// Sequential logic for D flip-flops
always @(posedge clk) begin
    q_xnor <= xnor_in;
    q_and <= and_in;
    q_or <= or_in;
end

// Initialize the flip-flops to zero
initial begin
    q_xnor = 1'b0;
    q_and = 1'b0;
    q_or = 1'b0;
end

// Define the output Z as the output of the three-input NOR gate
assign z = ~(q_xnor | q_and | q_or);

endmodule