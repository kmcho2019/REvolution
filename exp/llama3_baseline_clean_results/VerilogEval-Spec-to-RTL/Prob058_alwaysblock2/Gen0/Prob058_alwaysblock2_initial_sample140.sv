module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Method 1: Using assign statement
assign out_assign = a ^ b;

// Method 2: Using combinational always block
always @(*)
    out_always_comb = a ^ b;

// Method 3: Using clocked always block
always @(posedge clk)
    out_always_ff <= a ^ b;

endmodule