module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Continuous assignment with inline XOR
assign out_assign = a ^ b;

// Combinational always block with inline XOR
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block registering inline XOR on posedge clk
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule