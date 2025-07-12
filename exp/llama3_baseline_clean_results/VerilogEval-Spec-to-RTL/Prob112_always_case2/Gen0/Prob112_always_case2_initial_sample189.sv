module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) pos = 2'b11; // position 3
        else if (in[2]) pos = 2'b10; // position 2
        else if (in[1]) pos = 2'b01; // position 1
        else if (in[0]) pos = 2'b00; // position 0
        else pos = 2'b00; // if none of the bits are '1'
    end

endmodule