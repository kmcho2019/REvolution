module TopModule(
    input [7:0] in,
    output [2:0] pos
);

always @(in) begin
    pos = 3'd0; // Default output to 0 if no bits are high
    if (in[0]) pos = 3'd0; // Bit 0 is first bit that is high
    else if (in[1]) pos = 3'd1; // Bit 1 is first bit that is high
    else if (in[2]) pos = 3'd2; // Bit 2 is first bit that is high
    else if (in[3]) pos = 3'd3; // Bit 3 is first bit that is high
    else if (in[4]) pos = 3'd4; // Bit 4 is first bit that is high
    else if (in[5]) pos = 3'd5; // Bit 5 is first bit that is high
    else if (in[6]) pos = 3'd6; // Bit 6 is first bit that is high
    else if (in[7]) pos = 3'd7; // Bit 7 is first bit that is high
end

endmodule