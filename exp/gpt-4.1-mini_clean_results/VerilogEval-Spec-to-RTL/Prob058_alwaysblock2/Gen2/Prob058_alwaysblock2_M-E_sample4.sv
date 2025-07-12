module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_internal;
assign xor_internal = a ^ b;

// Assign output directly from the internal XOR wire
assign out_assign = xor_internal;

// Combinational block reads from internal XOR wire
always @(*) begin
    out_always_comb = xor_internal;
end

// Sequential block registers the internal XOR wire at posedge clk
always @(posedge clk) begin
    out_always_ff <= xor_internal;
end

endmodule