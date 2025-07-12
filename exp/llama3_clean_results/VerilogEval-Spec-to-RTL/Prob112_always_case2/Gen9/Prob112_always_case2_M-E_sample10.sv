module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[3]) pos = 2'b11; // MSB (4th position)
    else if (in[2]) pos = 2'b10; // Second MSB (3rd position)
    else if (in[1]) pos = 2'b01; // Second LSB (2nd position)
    else if (in[0]) pos = 2'b00; // LSB (1st position)
    else pos = 2'b00; // No '1' bits found
end

endmodule