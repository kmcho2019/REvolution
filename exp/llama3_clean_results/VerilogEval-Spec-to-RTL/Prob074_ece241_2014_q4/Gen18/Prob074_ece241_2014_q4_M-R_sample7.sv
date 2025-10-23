module TopModule(
    input clk,
    input x,
    output reg z
);

reg q0, q1, q2; // Individual D flip-flops

// Combinational logic for the gates
wire xor_out, and_out, or_out;

assign xor_out = x ^ q0;
assign and_out = x & ~q1;
assign or_out = x | ~q2;

// Sequential logic to update the flip-flops
always @(posedge clk) begin
    q0 <= xor_out;
    q1 <= and_out;
    q2 <= or_out;
end

// Combinational logic to compute the output 'z'
assign z = ~(xor_out | and_out | or_out);

endmodule