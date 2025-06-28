module TopModule (
    input clk,
    input x,
    output reg z // Output Z
);

reg [2:0] d_ff = 3'b0; // D flip-flops initialized to zero

// D flip-flops
always @(posedge clk)
begin
    if (x)
        d_ff <= d_ff + 1; // Increment the value in each flip-flop
end

// XOR gate
assign d_ff[0] = x ^ d_ff[0];
// AND gate
assign d_ff[1] = x & ~d_ff[1];
// OR gate
assign d_ff[2] = x | ~d_ff[2];

// Three-input NOR gate
assign z = ~(d_ff[0] | d_ff[1] | d_ff[2]);

endmodule