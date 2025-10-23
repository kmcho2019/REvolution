module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

wire xor_val;

// Compute XOR once and share
assign xor_val = a ^ b;

// Assign combinational output directly from xor_val
assign out_assign = xor_val;

// Combinational always block updating out_always_comb
always @(*) begin
    out_always_comb = xor_val;
end

// Sequential always block registering xor_val at posedge clk
always @(posedge clk) begin
    out_always_ff <= xor_val;
end

endmodule