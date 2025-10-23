module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Truth table for all possible 4-input combinations
    // Format: {out_and, out_or, out_xor}
    reg [2:0] lut [0:15];
    
    initial begin
        lut[4'b0000] = 3'b000;
        lut[4'b0001] = 3'b001;
        lut[4'b0010] = 3'b001;
        lut[4'b0011] = 3'b011;
        lut[4'b0100] = 3'b001;
        lut[4'b0101] = 3'b001;
        lut[4'b0110] = 3'b001;
        lut[4'b0111] = 3'b011;
        lut[4'b1000] = 3'b001;
        lut[4'b1001] = 3'b001;
        lut[4'b1010] = 3'b001;
        lut[4'b1011] = 3'b011;
        lut[4'b1100] = 3'b011;
        lut[4'b1101] = 3'b011;
        lut[4'b1110] = 3'b011;
        lut[4'b1111] = 3'b111;
    end

    // Output assignments
    assign {out_and, out_or, out_xor} = lut[in];

endmodule