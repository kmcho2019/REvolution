module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg = 4'b0000;

always @(posedge clk) begin
    if (!resetn) shift_reg <= 4'b0000;
    else shift_reg <= {in, shift_reg[3:1]};
end

assign out = shift_reg[0];

endmodule