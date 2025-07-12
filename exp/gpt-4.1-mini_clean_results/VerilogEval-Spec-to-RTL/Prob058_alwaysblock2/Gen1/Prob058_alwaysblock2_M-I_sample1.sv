module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Compute XOR once
wire xor_val = a ^ b;

// Use computed XOR for assign output
assign out_assign = xor_val;

// Combinational always block assigns from xor_val
always @(*) begin
    out_always_comb = xor_val;
end

// Sequential always block captures xor_val on posedge clk
always @(posedge clk) begin
    out_always_ff <= xor_val;
end

endmodule