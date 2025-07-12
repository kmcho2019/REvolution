module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or; // outputs of D flip-flops
wire xor_in, and_in, or_in; // inputs to XOR, AND, and OR gates

// XOR gate
assign xor_in = x ^ q_x;

// AND gate
assign and_in = x & ~q_and;

// OR gate
assign or_in = x | ~q_or;

// D flip-flops
always @(posedge clk) begin
    q_x <= xor_in;
    q_and <= and_in;
    q_or <= or_in;
end

// three-input NOR gate
assign z = ~(q_x | q_and | q_or);

// Initial reset of D flip-flops
initial begin
    q_x = 1'b0;
    q_and = 1'b0;
    q_or = 1'b0;
end

endmodule