module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3]) pos = 2'b11; // if most significant bit is '1', output position 3
    else if (in[2]) pos = 2'b10; // if second bit is '1', output position 2
    else if (in[1]) pos = 2'b01; // if third bit is '1', output position 1
    else if (in[0]) pos = 2'b00; // if least significant bit is '1', output position 0
    else pos = 2'b00; // if no '1' bit is found, output 0
end

endmodule