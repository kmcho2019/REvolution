module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;
reg d_reg;
reg d_stable;
wire clk_en;

// Clock gating control
assign clk_en = ~d_stable || (d != d_reg);

// Input register and stability detection
always @(posedge clk) begin
    d_reg <= d;
    d_stable <= (d == d_reg);
end

// Shift register with clock gating
always @(posedge clk) begin
    if (clk_en) begin
        shift_reg <= {d_reg, shift_reg[7:1]};
    end
end

// Output assignment
assign q = shift_reg;

// Initialization
initial begin
    shift_reg = 8'b0;
    d_reg = 1'b0;
    d_stable = 1'b0;
end

endmodule