module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3]) pos = 2'b11; // Position of the most significant bit
    else if (in[2]) pos = 2'b10;
    else if (in[1]) pos = 2'b01;
    else if (in[0]) pos = 2'b00; // Position of the least significant bit
    else pos = 2'b00; // If all bits are 0, output 0
end

endmodule