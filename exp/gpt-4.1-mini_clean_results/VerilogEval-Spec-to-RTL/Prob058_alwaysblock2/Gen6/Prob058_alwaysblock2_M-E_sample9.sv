module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Continuous assignment directly
assign out_assign = a ^ b;

// Combinational always block directly computes XOR
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block registers XOR at positive clock edge
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule