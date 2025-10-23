module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default output when no '1' bits are found

    // Check for '1' in each position and update output accordingly
    if (in[3] == 1'b1) pos = 2'b11; // MSB (4th position) -> 3
    else if (in[2] == 1'b1) pos = 2'b10; // Second MSB (3rd position) -> 2
    else if (in[1] == 1'b1) pos = 2'b01; // Second LSB (2nd position) -> 1
    // For LSB (1st position), we directly output 2'b00 as per the corrected understanding
end

endmodule