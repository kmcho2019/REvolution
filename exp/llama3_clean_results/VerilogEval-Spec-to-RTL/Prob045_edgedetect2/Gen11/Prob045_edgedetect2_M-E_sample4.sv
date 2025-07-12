module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {in, shift_reg[7:1]};
    anyedge <= in ^ shift_reg;
end

endmodule