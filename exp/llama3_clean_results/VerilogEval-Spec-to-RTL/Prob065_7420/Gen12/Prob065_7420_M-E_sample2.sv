module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y,
    input  clk // Clock input for the latch
);

// Shared 4-input NAND gate
wire nand_out;
assign nand_out = ~(p1a & p1b & p1c & p1d) ? (p1a & p1b & p1c & p1d) : ~(p2a & p2b & p2c & p2d);

// Control signal to select which output to generate
reg sel;
always @(posedge clk) begin
    sel <= ~sel;
end

// Latches to store the outputs
reg p1y_reg, p2y_reg;
always @(posedge clk) begin
    if (sel) begin
        p1y_reg <= ~nand_out;
    end else begin
        p2y_reg <= ~nand_out;
    end
end

// Output assignments
assign p1y = p1y_reg;
assign p2y = p2y_reg;

endmodule