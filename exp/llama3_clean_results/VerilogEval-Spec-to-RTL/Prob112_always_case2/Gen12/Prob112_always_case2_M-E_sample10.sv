module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) pos = 2'b11; // MSB is '1'
    else if (in[2] == 1'b1) pos = 2'b10; // Second MSB is '1'
    else if (in[1] == 1'b1) pos = 2'b01; // Second LSB is '1'
    else if (in[0] == 1'b1) pos = 2'b00; // LSB is '1'
    else pos = 2'b00; // No '1' bits found
end

endmodule