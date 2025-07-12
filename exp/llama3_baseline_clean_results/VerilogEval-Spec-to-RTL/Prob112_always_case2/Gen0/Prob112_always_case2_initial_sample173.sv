module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*)
    begin
        if (in[3]) 
            pos = 2'b11; // If the most significant bit is 1, output position 3
        else if (in[2]) 
            pos = 2'b10; // If the second most significant bit is 1, output position 2
        else if (in[1]) 
            pos = 2'b01; // If the second least significant bit is 1, output position 1
        else if (in[0]) 
            pos = 2'b00; // If the least significant bit is 1, output position 0
        else 
            pos = 2'b00; // If none of the bits are 1, output 0
    end

endmodule