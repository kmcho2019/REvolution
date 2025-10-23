module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Continuous combinational XOR
assign out_assign = a ^ b;

// Combinational always block for XOR output
always @(*) begin
    out_always_comb = a ^ b;
end

// Registers to detect input change for clock enable
reg a_reg, b_reg;
wire inputs_changed = (a_reg != a) || (b_reg != b);

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

// Sequential block with clock enable to reduce toggling
always @(posedge clk) begin
    if (inputs_changed)
        out_always_ff <= a ^ b;
end

endmodule