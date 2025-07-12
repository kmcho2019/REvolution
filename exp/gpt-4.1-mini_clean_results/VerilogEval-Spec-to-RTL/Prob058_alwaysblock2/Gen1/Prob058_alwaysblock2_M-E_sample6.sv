module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Internal wire holds XOR result
wire xor_result = a ^ b;

// Continuous assignment directly from xor_result
assign out_assign = xor_result;

// Combinational always block samples xor_result
always @* begin
    out_always_comb = xor_result;
end

// Two-stage sequential logic: delay xor_result by two clock cycles
reg ff1;
always @(posedge clk) begin
    ff1 <= xor_result;
    out_always_ff <= ff1;
end

endmodule