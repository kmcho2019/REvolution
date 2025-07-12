module TopModule(in, out);
    input [7:0] in;  // Input 8-bit number
    output [31:0] out;  // Output 32-bit sign-extended number

    assign out = {24{in[7]}, in};  // Sign-extend the input 8-bit number to 32 bits
endmodule