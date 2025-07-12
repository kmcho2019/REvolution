module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        if (in[3]) 
            pos = 2'b11;  // 3
        else if (in[2]) 
            pos = 2'b10;  // 2
        else if (in[1]) 
            pos = 2'b01;  // 1
        else if (in[0]) 
            pos = 2'b00;  // 0
        else 
            pos = 2'b00;  // output 0 if none of the bits are high
    end

endmodule