module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // MSB set, so output is 3
    else if (in[2] == 1'b1) 
        pos = 2'b10; // second bit set, so output is 2
    else if (in[1] == 1'b1) 
        pos = 2'b01; // third bit set, so output is 1
    else if (in[0] == 1'b1) 
        pos = 2'b00; // LSB set, so output is 0
    else 
        pos = 2'b00; // no bits set, so output is 0
end

endmodule