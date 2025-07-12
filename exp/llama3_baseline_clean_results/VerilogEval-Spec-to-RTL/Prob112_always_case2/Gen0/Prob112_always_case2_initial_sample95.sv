module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*)
    begin
        casez (in)
            4'b1000: pos = 2'b00; // The first bit is high
            4'b100:  pos = 2'b01; // The second bit is high
            4'b10:   pos = 2'b10; // The third bit is high
            4'b1:    pos = 2'b11; // The fourth bit is high
            default: pos = 2'b00; // None of the bits are high, or any other input value where the first '1' is in a lower position than the highest '1'
        endcase
    end

endmodule