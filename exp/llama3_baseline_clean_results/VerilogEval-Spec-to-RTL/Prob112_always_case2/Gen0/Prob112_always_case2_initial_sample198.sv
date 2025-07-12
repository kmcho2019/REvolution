module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // 3 in decimal
    else if (in[2] == 1'b1) 
        pos = 2'b10; // 2 in decimal
    else if (in[1] == 1'b1) 
        pos = 2'b01; // 1 in decimal
    else if (in[0] == 1'b1) 
        pos = 2'b00; // 0 in decimal
    else 
        pos = 2'b00; // Output 0 if no '1' bits are found
end

endmodule