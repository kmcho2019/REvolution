module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Intermediate wire for combinational XOR
wire xor_ab;
assign xor_ab = a ^ b;

// Combinational outputs driven from the intermediate wire
assign out_assign = xor_ab;

always @(*) begin
    out_always_comb = xor_ab;
end

// Sequential output registers the intermediate wire on clock edge
always @(posedge clk) begin
    out_always_ff <= xor_ab;
end

endmodule