module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Continuous assignment XOR
assign out_assign = a ^ b;

// Combinational always block XOR
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block XOR with clock edge triggering
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule