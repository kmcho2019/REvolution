module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], in[7]}; // Shift the input into the register
    anyedge <= (in[7]!= shift_reg[7])? 8'b1 : 8'b0; // Detect edge for the MSB
    anyedge[6:0] <= (in[6:0]!= shift_reg[6:0])? 7'b1 : 7'b0; // Detect edges for the rest
end

endmodule