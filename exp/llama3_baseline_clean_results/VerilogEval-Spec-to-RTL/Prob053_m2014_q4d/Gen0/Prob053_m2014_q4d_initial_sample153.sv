module TopModule(
    input clk,
    input in,
    output out
);

reg q; // Represents the flip-flop's output
wire xor_out; // Represents the output of the XOR gate

assign xor_out = in ^ q; // Calculate the XOR of 'in' and 'q'
assign out = q; // Drive the output 'out' with the flip-flop's output 'q'

always @(posedge clk) // On the positive edge of 'clk'
    q <= xor_out; // Capture the XOR gate's output into the flip-flop

endmodule