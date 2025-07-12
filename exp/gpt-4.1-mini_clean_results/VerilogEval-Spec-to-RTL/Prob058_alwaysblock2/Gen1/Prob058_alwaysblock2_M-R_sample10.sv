module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

wire xor_result;

// Compute XOR once
assign xor_result = a ^ b;

// Assign combinational outputs from xor_result
assign out_assign = xor_result;
assign out_always_comb = xor_result;

// Register xor_result on rising clock edge for sequential output
always @(posedge clk) begin
    out_always_ff <= xor_result;
end

endmodule