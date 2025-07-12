module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

wire xor_val;

// Compute XOR once using built-in operator
assign xor_val = a ^ b;

// Continuous assignment for combinational XOR output
assign out_assign = xor_val;

// Combinational always block assigning XOR value
always @(*) begin
    out_always_comb = xor_val;
end

// Sequential always block registering XOR on posedge clk
always @(posedge clk) begin
    out_always_ff <= xor_val;
end

endmodule