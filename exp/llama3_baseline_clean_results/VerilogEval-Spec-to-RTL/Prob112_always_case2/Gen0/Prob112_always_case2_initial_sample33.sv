module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // MSB position is 3
    else if (in[2] == 1'b1) 
        pos = 2'b10; // position is 2
    else if (in[1] == 1'b1) 
        pos = 2'b01; // position is 1
    else if (in[0] == 1'b1) 
        pos = 2'b00; // position is 0
    else 
        pos = 2'b00; // if none of the bits are high, output 0
end

endmodule