module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        pos = 2'b00; // default output
        if (in[3]) pos = 2'b10; // check MSB
        else if (in[2]) pos = 2'b01; // check second bit
        else if (in[1]) pos = 2'b10; // check third bit (bit 1, pos 2)
        else if (in[0]) pos = 2'b11; // check LSB
    end

endmodule