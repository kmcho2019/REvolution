module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Continuous assignment
assign out_assign = a ^ b;

// Combinational logic
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential logic with a positive edge clock trigger
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule