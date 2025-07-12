module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Initialize output to 2'b00
    if (in[3]) pos = 2'b11; // Check most significant bit first
    else if (in[2]) pos = 2'b10; // Check next bit if previous is not high
    else if (in[1]) pos = 2'b01; // Check next bit if previous is not high
    else if (in[0]) pos = 2'b00; // Check least significant bit
end

endmodule