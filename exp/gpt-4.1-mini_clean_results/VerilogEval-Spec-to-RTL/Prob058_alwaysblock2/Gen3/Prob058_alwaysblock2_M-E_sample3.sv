module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Intermediate combinational XOR signal
wire xor_result;
assign xor_result = a ^ b;

// Continuous assignment output directly driven by xor_result
assign out_assign = xor_result;

// Combinational always block sampling the xor_result
always @(*) begin
    out_always_comb = xor_result;
end

// Sequential block registering xor_result on clock edge
always @(posedge clk) begin
    out_always_ff <= xor_result;
end

endmodule