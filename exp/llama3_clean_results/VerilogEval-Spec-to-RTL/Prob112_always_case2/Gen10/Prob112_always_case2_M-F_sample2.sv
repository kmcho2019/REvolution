module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

reg [1:0] pos; // Declare pos as a reg for procedural assignment

always @(*) begin
    // Prioritize the most significant bit
    if (in[3] == 1'b1) pos = 2'b01; // MSB position is 1
    else if (in[2] == 1'b1) pos = 2'b10; // Second MSB position is 2
    else if (in[1] == 1'b1) pos = 2'b11; // Third MSB position is 3
    else if (in[0] == 1'b1) pos = 2'b00; // LSB position is 0
    else pos = 2'b00; // If no '1' is found, default to 0
end

endmodule