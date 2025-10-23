module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

wire ref0, ref1, ref2, ref3;

assign ref0 = 1'b1; // Reference for the most significant bit
assign ref1 = ~in[3]; // Reference for the second bit is '1' only if the first bit is '0'
assign ref2 = ~in[3] & ~in[2]; // Reference for the third bit is '1' only if the first two bits are '0'
assign ref3 = ~in[3] & ~in[2] & ~in[1]; // Reference for the least significant bit is '1' only if the first three bits are '0'

always @(*) begin
    pos = 2'b00; // Default output
    if (in[3] & ref0) pos = 2'b00; // If the most significant bit is '1', output '2'b00'
    else if (in[2] & ref1) pos = 2'b01; // If the second bit is '1' and the first is '0', output '2'b01'
    else if (in[1] & ref2) pos = 2'b10; // If the third bit is '1' and the first two are '0', output '2'b10'
    else if (in[0] & ref3) pos = 2'b11; // If the least significant bit is '1' and the first three are '0', output '2'b11'
end

endmodule