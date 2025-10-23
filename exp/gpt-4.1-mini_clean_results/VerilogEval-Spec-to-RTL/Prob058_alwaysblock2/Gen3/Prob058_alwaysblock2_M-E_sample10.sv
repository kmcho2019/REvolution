module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Internal combinational XOR wire
wire xor_result;
assign xor_result = a ^ b;

// Continuous assignment output
assign out_assign = xor_result;

// Combinational always block output
always @(*) begin
    out_always_comb = xor_result;
end

// Sequential always block output (registered)
always @(posedge clk) begin
    out_always_ff <= xor_result;
end

endmodule