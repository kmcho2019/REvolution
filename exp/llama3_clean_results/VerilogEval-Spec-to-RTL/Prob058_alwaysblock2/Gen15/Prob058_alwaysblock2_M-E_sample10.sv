module TopModule(
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

always @(posedge clk) begin
    out_assign <= a ^ b;
    out_always_comb <= a ^ b;
    out_always_ff <= out_assign;
end

endmodule