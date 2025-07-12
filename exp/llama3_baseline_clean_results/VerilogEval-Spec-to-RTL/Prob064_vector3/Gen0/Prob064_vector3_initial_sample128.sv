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

wire [29:0] concatenated_input;  // Concatenated 30-bit input vector
wire [31:0] output_vector;        // 32-bit output vector with two 1 bits appended

assign concatenated_input = {a, b, c, d, e, f};
assign output_vector = {concatenated_input, 2'b11};

assign w = output_vector[31:24];  // Assign the MSB 8 bits to w
assign x = output_vector[23:16];  // Assign the next 8 bits to x
assign y = output_vector[15:8];   // Assign the next 8 bits to y
assign z = output_vector[7:0];    // Assign the LSB 8 bits to z

endmodule