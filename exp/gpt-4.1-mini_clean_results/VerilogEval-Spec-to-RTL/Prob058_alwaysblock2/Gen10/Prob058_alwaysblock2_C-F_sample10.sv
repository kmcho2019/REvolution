module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Shared intermediate wire for XOR
wire xor_ab = a ^ b;

// Continuous assignment for out_assign
assign out_assign = xor_ab;

// Combinational always block using blocking assignment
always @(*) begin
    out_always_comb = xor_ab;
end

// Sequential always block with nonblocking assignment
always @(posedge clk) begin
    out_always_ff <= xor_ab;
end

endmodule