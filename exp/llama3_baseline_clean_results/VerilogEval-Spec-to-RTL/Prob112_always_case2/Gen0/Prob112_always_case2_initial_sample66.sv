module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3] == 1'b1)
        pos = 2'b11; // Position of MSB is 3
    else if (in[2] == 1'b1)
        pos = 2'b10; // Position of second bit is 2
    else if (in[1] == 1'b1)
        pos = 2'b01; // Position of third bit is 1
    else if (in[0] == 1'b1)
        pos = 2'b00; // Position of LSB is 0
    else
        pos = 2'b00; // If no '1' is found, output 0
end

endmodule