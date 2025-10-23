module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // Position 3
    else if (in[2] == 1'b1) 
        pos = 2'b10; // Position 2
    else if (in[1] == 1'b1) 
        pos = 2'b01; // Position 1
    else if (in[0] == 1'b1) 
        pos = 2'b00; // Position 0
    else 
        pos = 2'b00; // Default to 0 if no '1' is found
end

endmodule