module TopModule(
    input [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, you can use a more concise syntax to achieve the same result:
// assign out = in[0] ? 8'b00000001 : in[1] ? 8'b00000010 : in[2] ? 8'b00000100 : in[3] ? 8'b00001000 : in[4] ? 8'b00010000 : in[5] ? 8'b00100000 : in[6] ? 8'b01000000 : in[7] ? 8'b10000000 : 8'b00000000;
// However, a simple and more readable approach to reverse bits in Verilog is to use the above approach or the following syntax:
// assign out = in[7:0];

// Yet another concise and efficient approach:
assign out = in[7] ? 8'b10000000 : 
             in[6] ? 8'b01000000 : 
             in[5] ? 8'b00100000 : 
             in[4] ? 8'b00010000 : 
             in[3] ? 8'b00001000 : 
             in[2] ? 8'b00000100 : 
             in[1] ? 8'b00000010 : 
             in[0] ? 8'b00000001 : 8'b00000000;

// Most efficiently, though:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule