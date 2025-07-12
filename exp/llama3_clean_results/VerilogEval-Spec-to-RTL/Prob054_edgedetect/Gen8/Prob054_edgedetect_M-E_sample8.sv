module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], in[7]};
end

assign pedge = (in & ~shift_reg);

endmodule