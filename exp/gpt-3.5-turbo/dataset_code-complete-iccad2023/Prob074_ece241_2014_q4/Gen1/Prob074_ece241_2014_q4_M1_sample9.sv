module TopModule (
    input clk,
    input x,
    output reg z // Output Z
);

reg [2:0] d_ff = 3'b000; // D flip-flop outputs, initialized to zero

// D flip-flops
always @(posedge clk)
begin
    d_ff[0] <= x ^ d_ff[0]; // XOR gate connection
    d_ff[1] <= x & ~d_ff[1]; // AND gate connection
    d_ff[2] <= x | ~d_ff[2]; // OR gate connection
end

// Three-input NOR gate
assign z = ~(d_ff[0] | d_ff[1] | d_ff[2]);

endmodule