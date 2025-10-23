module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] lfsr_reg;
wire [9:0] next_lfsr;

assign next_lfsr = (lfsr_reg == 10'd0) ? 10'd0 : (lfsr_reg - 1);

always @(posedge clk)
    if (load)
        lfsr_reg <= data;
    else
        lfsr_reg <= next_lfsr;

assign tc = (lfsr_reg == 10'd0);

endmodule