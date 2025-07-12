module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [15:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {in, shift_reg[15:8]};
    anyedge <= shift_reg[7:0] ^ shift_reg[15:8];
end

endmodule