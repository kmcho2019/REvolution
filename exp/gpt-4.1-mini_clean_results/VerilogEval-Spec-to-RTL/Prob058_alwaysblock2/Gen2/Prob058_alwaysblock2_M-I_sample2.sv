module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Single XOR computation reused
wire xor_result = a ^ b;

// Continuous assign statement XOR using the shared XOR result
assign out_assign = xor_result;

// Combinational always block drives out_always_comb from shared XOR result
always @(*) begin
    out_always_comb = xor_result;
end

// Sequential always block XOR with one clock cycle delay
always @(posedge clk) begin
    out_always_ff <= xor_result;
end

endmodule