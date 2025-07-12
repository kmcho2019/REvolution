module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    // Default to 0 if no '1' bits are found
    pos = 2'b00; 
    
    // Check each bit from MSB to LSB and assign the corresponding position
    if (in[3]) pos = 2'b11; // MSB is position 3
    else if (in[2]) pos = 2'b10; // Second MSB is position 2
    else if (in[1]) pos = 2'b01; // Second LSB is position 1
    else if (in[0]) pos = 2'b00; // LSB is position 0
end

endmodule