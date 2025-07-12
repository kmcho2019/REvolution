module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

wire [29:0] inputs;  // 30-bit vector to hold the concatenated inputs
wire [31:0] temp;    // 32-bit vector to hold the inputs with two 1 bits appended

assign inputs = {a, b, c, d, e, f};  // concatenate the input vectors
assign temp = {inputs, 2'b11};      // append two 1 bits to the end of the inputs

assign w = temp[31:24];  // split the 32-bit vector into 8-bit output vectors
assign x = temp[23:16];
assign y = temp[15:8];
assign z = temp[7:0];

endmodule