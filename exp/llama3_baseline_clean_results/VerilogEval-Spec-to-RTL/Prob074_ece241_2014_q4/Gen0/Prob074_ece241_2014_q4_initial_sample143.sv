module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;
wire xor_in, and_in, or_in, nor_in1, nor_in2, nor_in3;

// Define the three two-input gates
assign xor_in = x ^ q_xor;
assign and_in = x & ~q_and;
assign or_in = x | ~q_or;

// Define the D flip-flops
always @(posedge clk) begin
    q_xor <= xor_in;
    q_and <= and_in;
    q_or <= or_in;
end

// Define the three-input NOR gate
assign nor_in1 = q_xor;
assign nor_in2 = q_and;
assign nor_in3 = q_or;
assign z = ~(nor_in1 | nor_in2 | nor_in3);

// Initialize the D flip-flops to 0
initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule