module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Continuous assignment with built-in XOR operator
assign out_assign = a ^ b;

always @(*) begin
    // Simplified combinational XOR using the built-in operator
    out_always_comb = a ^ b;
end

always @(posedge clk) begin
    // Sequential logic: register the XOR result directly
    out_always_ff <= a ^ b;
end

endmodule