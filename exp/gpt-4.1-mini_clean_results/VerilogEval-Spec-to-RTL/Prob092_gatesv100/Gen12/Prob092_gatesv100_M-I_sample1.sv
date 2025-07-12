module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    // Implemented via concatenation to assign full vector at once
    assign out_both = {99{1'b0}} | (in[98:0] & in[99:1]);

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    // Construct full vector by concatenating zero at bit 0, then OR of neighbors
    assign out_any = {1'b0, in[99:1] | in[98:0]};

    // out_different[i] = in[i] ^ in[(i-1) mod 100], wrap-around XOR using concatenation
    assign out_different = in ^ {in[0], in[99:1]};

endmodule