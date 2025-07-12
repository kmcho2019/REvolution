module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_register;
assign tc = (shift_register == 10'd0);

always @(posedge clk)
    if (load)
        shift_register <= {10{1'b1}} & (data + 1);
    else if (shift_register != 10'd0)
        shift_register <= shift_register >> 1;

endmodule