module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Direct continuous assignment using XOR operator
assign out_assign = a ^ b;

// Combinational always block with direct XOR operator
always_comb begin
    out_always_comb = a ^ b;
end

// Sequential logic: register the XOR result on positive clock edge
always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule