module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk)
    if (!resetn) shift_reg <= 0;
    else shift_reg <= {in, shift_reg[3:1]};

assign out = shift_reg[0];

endmodule