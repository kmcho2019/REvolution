module TopModule(
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

// Define the lookup table (LUT) for the logic gates
reg [6:0] lut_out;
always @(*) begin
    case({a, b})
        2'b00: lut_out = 7'b0000000; // a=0, b=0
        2'b01: lut_out = 7'b0000001; // a=0, b=1
        2'b10: lut_out = 7'b0000011; // a=1, b=0
        2'b11: lut_out = 7'b0000111; // a=1, b=1
    endcase
end

// Assign the LUT outputs to the corresponding logic gates
assign out_and  = lut_out[0]; // AND gate
assign out_or   = lut_out[1]; // OR gate
assign out_xor  = lut_out[2]; // XOR gate
assign out_nand = lut_out[3]; // NAND gate
assign out_nor  = lut_out[4]; // NOR gate
assign out_xnor = lut_out[5]; // XNOR gate
assign out_anotb = lut_out[6]; // AND-NOT gate

endmodule