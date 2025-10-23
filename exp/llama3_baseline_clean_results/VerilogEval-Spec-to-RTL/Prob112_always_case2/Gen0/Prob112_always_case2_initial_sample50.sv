module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3]) pos = 2'b11; // MSB has highest priority
    else if (in[2]) pos = 2'b10;
    else if (in[1]) pos = 2'b01;
    else if (in[0]) pos = 2'b00;
    else pos = 2'b00; // if none of the input bits are high
end

endmodule