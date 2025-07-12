module TopModule(in, pos);
    input [3:0] in;
    output [1:0] pos;

    always @(in) begin
        casez (in)
            4'b1000: pos = 2'b01; // bit 3 is the first high bit
            4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b01;
            4'b0100: pos = 2'b10; // bit 2 is the first high bit
            4'b0101, 4'b0110, 4'b0111: pos = 2'b10;
            4'b0010: pos = 2'b11; // bit 1 is the first high bit
            4'b0011: pos = 2'b11;
            4'b0001: pos = 2'b00; // bit 0 is the first high bit (using pos = 2'b00 for this case, but can be adjusted based on desired behavior)
            default: pos = 2'b00; // none of the input bits are high
        endcase
    end

    // Alternative way to write the same using if-else statement
    // always @(in) begin
    //     if (in[3]) pos = 2'b01;
    //     else if (in[2]) pos = 2'b10;
    //     else if (in[1]) pos = 2'b11;
    //     else if (in[0]) pos = 2'b00; // Note that using 2'b00 here for bit 0 being high
    //     else pos = 2'b00; // none of the input bits are high
    // end
endmodule