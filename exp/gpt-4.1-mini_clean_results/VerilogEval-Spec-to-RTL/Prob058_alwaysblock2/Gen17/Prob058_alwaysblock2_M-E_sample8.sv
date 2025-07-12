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
    // Behavioral XOR using if-else (without ^ operator)
    if (a == b)
        out_always_comb = 1'b0;
    else
        out_always_comb = 1'b1;
end

always @(posedge clk) begin
    // Sequential logic: register the XOR result computed here directly
    if (a == b)
        out_always_ff <= 1'b0;
    else
        out_always_ff <= 1'b1;
end

endmodule