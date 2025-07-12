module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Implementing an XOR gate using an assign statement
assign out_assign = a ^ b;

// Implementing an XOR gate using a combinational always block
always @(*) begin
    out_always_comb = a ^ b;
end

// Implementing an XOR gate using a clocked always block
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule