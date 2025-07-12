module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Using assign statement for continuous assignment
assign out_assign = a ^ b;

// Using combinational always block for procedural continuous assignment
always @(*) begin
    out_always_comb = a ^ b;
end

// Using clocked always block to create a sequential logic circuit with a flip-flop
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule