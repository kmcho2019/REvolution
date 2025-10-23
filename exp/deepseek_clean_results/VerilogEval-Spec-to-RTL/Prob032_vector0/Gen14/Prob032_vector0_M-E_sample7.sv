module BitMirrorUnit(
    input in_bit,
    output out_bit,
    output vec_bit
);
    assign out_bit = in_bit;
    assign vec_bit = in_bit;
endmodule

module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    BitMirrorUnit bit2(.in_bit(vec[2]), .out_bit(o2), .vec_bit(outv[2]));
    BitMirrorUnit bit1(.in_bit(vec[1]), .out_bit(o1), .vec_bit(outv[1]));
    BitMirrorUnit bit0(.in_bit(vec[0]), .out_bit(o0), .vec_bit(outv[0]));

endmodule