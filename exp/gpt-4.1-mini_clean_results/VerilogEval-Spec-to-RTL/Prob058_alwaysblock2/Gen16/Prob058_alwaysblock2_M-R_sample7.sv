module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Direct continuous assignment using XOR operator
assign out_assign = a ^ b;

// Combinational always block with direct XOR operator
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block: single flip-flop registering XOR result
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule