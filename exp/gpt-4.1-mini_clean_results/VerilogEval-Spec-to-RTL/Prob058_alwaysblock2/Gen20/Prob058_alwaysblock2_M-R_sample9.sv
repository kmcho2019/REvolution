module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Continuous assignment directly computing XOR
assign out_assign = a ^ b;

// Combinational always block with inline XOR
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block registering XOR result at posedge clk
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule