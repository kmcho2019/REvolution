module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // default output is 0 if no 1 bit is found
    if (in[3]) pos = 2'b11; // check MSB
    else if (in[2]) pos = 2'b10; // check second MSB
    else if (in[1]) pos = 2'b01; // check second LSB
    else if (in[0]) pos = 2'b00; // check LSB
end

endmodule