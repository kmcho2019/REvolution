module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg = 4'b0000;

always @(posedge clk) begin
    shift_reg <= resetn ? {in, shift_reg[3:1]} : 4'b0000;
end

assign out = shift_reg[0];

endmodule