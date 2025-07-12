module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Continuous assignment
always @(*) begin
    out_assign = a ^ b;
end

// Combinational always block
always_comb begin
    out_always_comb = a ^ b;
end

// Clocked always block
always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule