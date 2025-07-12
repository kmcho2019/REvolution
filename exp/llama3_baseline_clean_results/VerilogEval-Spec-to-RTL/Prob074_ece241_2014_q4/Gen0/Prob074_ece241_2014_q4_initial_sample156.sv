module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] q; // D flip-flop outputs
wire [2:0] d; // D flip-flop inputs

// XOR gate
assign d[0] = x ^ q[0];

// AND gate
assign d[1] = x & ~q[1];

// OR gate
assign d[2] = x | ~q[2];

// D flip-flops
always @(posedge clk) begin
    q <= d;
end

// NOR gate
assign z = ~(d[0] | d[1] | d[2]);

// Initialize the D flip-flops to zero
initial begin
    q <= 3'b000;
end

endmodule