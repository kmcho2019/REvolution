module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_reg;
assign tc = shift_reg[9];

always @(posedge clk)
    if (load)
        shift_reg <= {10{1'b0}} | (data[9] ? 10'd1023 : (1 << data));
    else if (shift_reg != 10'd0)
        shift_reg <= shift_reg >> 1;

endmodule