module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default to 0 if no '1' bits are found
    if (in[3]) pos = 2'b11; // MSB is the 4th position
    else if (in[2]) pos = 2'b10; // 3rd position
    else if (in[1]) pos = 2'b01; // 2nd position
    else if (in[0]) pos = 2'b00; // LSB is the 1st position
end

endmodule