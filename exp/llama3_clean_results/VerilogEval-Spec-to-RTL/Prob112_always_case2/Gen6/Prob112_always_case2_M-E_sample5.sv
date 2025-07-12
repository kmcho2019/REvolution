module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default output when no '1' bits are found

    // Check for '1' in each position and update output accordingly
    if (in[3] == 1'b1) pos = 2'b11; // MSB (4th position)
    else if (in[2] == 1'b1) pos = 2'b10; // Second MSB (3rd position)
    else if (in[1] == 1'b1) pos = 2'b01; // Second LSB (2nd position)
    else if (in[0] == 1'b1) pos = 2'b00; // LSB (1st position)
end

endmodule