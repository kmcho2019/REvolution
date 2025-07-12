module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or; // outputs of the D flip-flops

// Combinational logic for the gates
wire xor_in, and_in, or_in;
wire xor_out, and_out, or_out;

assign xor_in = q_xor ^ x;
assign and_in = q_and && ~q_and;
assign or_in = q_or || ~q_or;

assign xor_out = x ^ q_xor;
assign and_out = x && ~q_and;
assign or_out = x || ~q_or;

// D flip-flops
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Three-input NOR gate
assign z = ~(xor_out || and_out || or_out);

endmodule