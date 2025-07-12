module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[3]) pos = 2'b11;  // MSB (3) is 1
    else if (in[2]) pos = 2'b10;  // Second bit (2) is 1
    else if (in[1]) pos = 2'b01;  // Third bit (1) is 1
    else if (in[0]) pos = 2'b00;  // LSB (0) is 1
    else pos = 2'b00;  // No '1' bit found, output 0
end

endmodule