module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Create a mask where each bit is '1' if all higher bits are '0'
wire [3:0] mask;
assign mask[0] = 1'b1;  // Always consider LSB
assign mask[1] = ~in[0];
assign mask[2] = ~in[0] & ~in[1];
assign mask[3] = ~in[0] & ~in[1] & ~in[2];

// AND the mask with input to find first '1'
wire [3:0] first_one = in & mask;

// Encode the position using priority case statement
reg [1:0] pos_reg;
always @(*) begin
    casez (first_one)
        4'b???1: pos_reg = 2'b00;
        4'b??10: pos_reg = 2'b01;
        4'b?100: pos_reg = 2'b10;
        4'b1000: pos_reg = 2'b11;
        default: pos_reg = 2'b00;  // All zeros case
    endcase
end

assign pos = pos_reg;

endmodule