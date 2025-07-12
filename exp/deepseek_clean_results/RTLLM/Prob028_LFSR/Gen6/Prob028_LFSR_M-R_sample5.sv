module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

wire feedback;
reg [3:0] out_reg;

// Feedback calculation
assign feedback = out_reg[3] ^ out_reg[2];

// Register update with clock and reset
assign out = out_reg;
always @(posedge clk) out_reg <= rst ? 4'b0001 : {out_reg[2:0], feedback};

endmodule