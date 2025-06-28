module TopModule (
    input clk,
    input in,
    output reg out
);

// D flip-flop without reset
reg d_ff;
always @(posedge clk)
    d_ff <= in ^ ~out;

// Two-input XOR gate
assign out = d_ff;

endmodule