module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out; // outputs of the D flip-flops

// Combinational logic for the XOR, AND, and OR gates
wire xor_in = x ^ xor_out;
wire and_in = x & ~and_out;
wire or_in = x | ~or_out;

// Sequential logic for the D flip-flops
always @(posedge clk) begin
    xor_out <= xor_in;
    and_out <= and_in;
    or_out <= or_in;
end

// Combinational logic for the NOR gate
assign z = ~(xor_out | and_out | or_out);

// Initial block to reset the D flip-flops to zero
initial begin
    xor_out = 0;
    and_out = 0;
    or_out = 0;
end

endmodule