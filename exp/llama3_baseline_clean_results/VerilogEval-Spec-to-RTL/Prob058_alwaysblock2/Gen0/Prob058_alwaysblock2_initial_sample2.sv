module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Using assign statement to create a combinational XOR gate
assign out_assign = a ^ b;

// Using always_comb block to create a combinational XOR gate
always_comb begin
    out_always_comb = a ^ b;
end

// Using always_ff block to create a clocked XOR gate with a flip-flop
always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule