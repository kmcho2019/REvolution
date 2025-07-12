module TopModule(in, out);
    input [7:0] in;
    output [31:0] out;

    assign out = {24{in[7]}, in}; // Replicate MSB 24 times and concatenate with the 8-bit number

endmodule