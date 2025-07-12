module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] q; // outputs of the D flip-flops

// XOR gate
wire xor_out = x ^ q[0];

// AND gate
wire and_out = x & ~q[1];

// OR gate
wire or_out = x | ~q[2];

// NOR gate
assign z = ~(xor_out | and_out | or_out);

// D flip-flops
always_ff @(posedge clk) begin
    q[0] <= xor_out;
    q[1] <= and_out;
    q[2] <= or_out;
end

endmodule