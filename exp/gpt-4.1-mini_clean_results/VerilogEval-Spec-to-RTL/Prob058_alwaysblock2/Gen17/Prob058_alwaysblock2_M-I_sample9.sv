module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Direct assign statement implementing XOR
assign out_assign = a ^ b;

// Combinational always block using direct XOR operator
always @(*) begin
    out_always_comb = a ^ b;
end

// Register to hold previous inputs for clock enable
reg a_reg, b_reg;
wire clk_en;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

// Enable clocked XOR output update only if inputs changed
assign clk_en = (a_reg != a) || (b_reg != b);

// Sequential always block with clock enable to reduce toggling
always @(posedge clk) begin
    if (clk_en) begin
        out_always_ff <= a ^ b;
    end
end

endmodule