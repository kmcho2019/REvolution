module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) 
        pos = 2'b11; // Most significant bit
    else if (in[2] == 1'b1) 
        pos = 2'b10; 
    else if (in[1] == 1'b1) 
        pos = 2'b01; 
    else if (in[0] == 1'b1) 
        pos = 2'b00; // Least significant bit
    else 
        pos = 2'b00; // If none of the bits are high, output 0
end

endmodule