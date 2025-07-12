module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Direct assign statement with XOR of inputs
assign out_assign = a ^ b;

// Combinational always block computing XOR directly
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block registering XOR of inputs at clock's positive edge
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule