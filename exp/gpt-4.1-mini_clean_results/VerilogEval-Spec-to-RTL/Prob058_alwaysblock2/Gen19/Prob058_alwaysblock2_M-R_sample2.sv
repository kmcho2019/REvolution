module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

// Direct assign for combinational XOR output
assign out_assign = a ^ b;

// Continuous assignment for combinational always_comb output
assign out_always_comb = a ^ b;

// Intermediate wire to hold combinational XOR result for sequential logic
wire xor_comb;
assign xor_comb = a ^ b;

// Sequential always block to register XOR on rising clock edge
always @(posedge clk) begin
    out_always_ff <= xor_comb;
end

endmodule