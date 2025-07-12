module TopModule(
    input clk,
    input in,
    output out
);

reg dff_out; // Internal signal for the flip-flop's output
wire xor_out; // Intermediate wire for XOR output

// Combinational logic: XOR gate
assign xor_out = in ^ dff_out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    dff_out <= xor_out;
end

// Drive the output from the flip-flop's output
assign out = dff_out;

endmodule