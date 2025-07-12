module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3] == 1'b1)
        pos = 2'b11; // Position of bit 3 is 11 in binary
    else if (in[2] == 1'b1)
        pos = 2'b10; // Position of bit 2 is 10 in binary
    else if (in[1] == 1'b1)
        pos = 2'b01; // Position of bit 1 is 01 in binary
    else if (in[0] == 1'b1)
        pos = 2'b00; // Position of bit 0 is 00 in binary
    else
        pos = 2'b00; // If all bits are 0, output 00
end

endmodule