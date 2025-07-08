module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Combinational XOR using assign
assign out_assign = a ^ b;

// Combinational XOR using always_comb
always @* begin
    out_always_comb = a ^ b;
end

// Sequential XOR using always_ff on posedge clk
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule