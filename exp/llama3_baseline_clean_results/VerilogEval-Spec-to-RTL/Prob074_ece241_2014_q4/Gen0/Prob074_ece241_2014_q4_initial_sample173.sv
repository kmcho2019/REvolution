module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg dff_xor, dff_and, dff_or;
wire xor_ff, and_ff, or_ff;

// Continuous assignments for the XOR, AND, and OR gates
assign xor_out = x ^ dff_xor;
assign and_out = x & ~dff_and;
assign or_out = x | ~dff_or;

// Continuous assignments for the NOR gate
assign z = ~(xor_out | and_out | or_out);

// Sequential logic for the D flip-flops
always @(posedge clk) begin
    dff_xor <= xor_out;
    dff_and <= and_out;
    dff_or <= or_out;
end

endmodule