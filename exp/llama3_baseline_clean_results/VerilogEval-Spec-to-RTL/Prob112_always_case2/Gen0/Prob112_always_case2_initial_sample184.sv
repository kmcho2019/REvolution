module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(in) begin
    if (in[3]) 
        pos = 2'b10; // bit 3 is high
    else if (in[2]) 
        pos = 2'b01; // bit 2 is high
    else if (in[1]) 
        pos = 2'b00; // bit 1 is high (output is 2'b00 because pos is 2 bits wide and we start from 0)
    else if (in[0]) 
        pos = 2'b00; // bit 0 is high
    else 
        pos = 2'b00; // none of the bits are high
end

endmodule