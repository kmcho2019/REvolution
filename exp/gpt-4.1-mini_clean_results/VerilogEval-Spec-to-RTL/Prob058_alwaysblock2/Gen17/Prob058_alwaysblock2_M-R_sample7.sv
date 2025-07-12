module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

// Continuous assignment for XOR using assign (no gate instantiation)
assign out_assign = a ^ b;

// Combinational XOR using assign instead of always block
assign out_always_comb = a ^ b;

// Sequential always block registering XOR on posedge clk
always @(posedge clk) begin
    // Using blocking assignment here to show stylistic difference
    out_always_ff = a ^ b;
end

endmodule