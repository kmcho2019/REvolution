module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {in, 8'b0}; // Shift in the new input and discard the oldest bit
end

assign pedge = (in & ~shift_reg[7:0]); // Compare current input with the previous input

endmodule