module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(in) begin
    if (in[3]) pos = 2'b11; // Most significant bit is 1, so output 3
    else if (in[2]) pos = 2'b10; // Second most significant bit is 1, so output 2
    else if (in[1]) pos = 2'b01; // Second least significant bit is 1, so output 1
    else if (in[0]) pos = 2'b00; // Least significant bit is 1, so output 0
    else pos = 2'b00; // No 1 bit found, output 0
end

endmodule