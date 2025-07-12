module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Encode the input conditions
wire [3:0] encoded_input = {a, b, c, d};

// Use a 4-to-1 multiplexer to select the output
wire [3:0] desired_outputs = 4'b00000011; // 1 for inputs 2, 7, and 15
wire [3:0] undesired_outputs = 4'b11110001; // 0 for inputs 0, 1, 4, 5, 6, 9, 10, 13, and 14

// Sum-of-products (SOP) expression
assign out_sop = (encoded_input == 4'b0010) | (encoded_input == 4'b0111) | (encoded_input == 4'b1111);

// Product-of-sums (POS) expression
assign out_pos = ~( (encoded_input == 4'b0000) | (encoded_input == 4'b0001) | (encoded_input == 4'b0100) | 
                   (encoded_input == 4'b0101) | (encoded_input == 4'b0110) | (encoded_input == 4'b1001) | 
                   (encoded_input == 4'b1010) | (encoded_input == 4'b1101) | (encoded_input == 4'b1110) );

endmodule