// TopModule: a full adder using a lookup table approach
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output cout,  // carry-out bit
    output sum  // sum bit
);

// Define the lookup table for sum and carry-out
reg [1:0] lut_out;
always @(*) begin
    case ({a, b, cin})
        3'b000: lut_out = 2'b00; // sum = 0, cout = 0
        3'b001: lut_out = 2'b01; // sum = 1, cout = 0
        3'b010: lut_out = 2'b01; // sum = 1, cout = 0
        3'b011: lut_out = 2'b10; // sum = 0, cout = 1
        3'b100: lut_out = 2'b01; // sum = 1, cout = 0
        3'b101: lut_out = 2'b10; // sum = 0, cout = 1
        3'b110: lut_out = 2'b10; // sum = 0, cout = 1
        3'b111: lut_out = 2'b11; // sum = 1, cout = 1
    endcase
end

// Assign the sum and carry-out from the LUT
assign sum = lut_out[0];
assign cout = lut_out[1];

endmodule