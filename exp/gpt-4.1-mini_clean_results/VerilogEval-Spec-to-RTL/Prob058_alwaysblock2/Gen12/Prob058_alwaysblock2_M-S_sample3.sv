module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

assign out_assign = a ^ b;
assign out_always_comb = out_assign; // share combinational output directly
always @(posedge clk) out_always_ff <= out_assign;

endmodule