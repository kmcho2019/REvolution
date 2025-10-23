module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // Position of the most significant bit (3) is 3
    else if (in[2] == 1'b1) 
        pos = 2'b10; // Position of the second bit (2) is 2
    else if (in[1] == 1'b1) 
        pos = 2'b01; // Position of the third bit (1) is 1
    else if (in[0] == 1'b1) 
        pos = 2'b00; // Position of the least significant bit (0) is 0
    else 
        pos = 2'b00; // If no 1 bit is found, output 0
end

endmodule