module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] q; // outputs of the D flip-flops
wire xor_out, and_out, or_out; // outputs of the XOR, AND, and OR gates

// XOR gate with second input as its corresponding flip-flop's output
assign xor_out = x ^ q[0];

// AND gate with second input as its corresponding flip-flop's complemented output
assign and_out = x & ~q[1];

// OR gate with second input as its corresponding flip-flop's complemented output
assign or_out = x | ~q[2];

// D flip-flops
always @(posedge clk) begin
    q[0] <= xor_out;
    q[1] <= and_out;
    q[2] <= or_out;
end

// NOR gate to generate the output z
assign z = ~(q[0] | q[1] | q[2]);

endmodule