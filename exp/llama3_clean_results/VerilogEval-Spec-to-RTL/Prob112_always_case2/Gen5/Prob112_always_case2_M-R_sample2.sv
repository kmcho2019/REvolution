module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    assign pos = (
        (in[3] == 1'b1)? 2'b11 :
        (in[2] == 1'b1)? 2'b10 :
        (in[1] == 1'b1)? 2'b01 :
        (in[0] == 1'b1)? 2'b00 :
        2'b00 // Default output when no '1' bits are found
    );

endmodule