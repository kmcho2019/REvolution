module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out = 1'b0, and_out = 1'b0, or_out = 1'b0;
wire xor_next, and_next, or_next;

// Combinational logic for the gates
assign xor_next = x ^ xor_out;
assign and_next = x & ~and_out;
assign or_next = x | ~or_out;

// Sequential logic for the D flip-flops
always @(posedge clk) begin
    xor_out <= xor_next;
    and_out <= and_next;
    or_out <= or_next;
end

// Output z is the NOR of the flip-flop outputs
assign z = ~(xor_out | and_out | or_out);

endmodule