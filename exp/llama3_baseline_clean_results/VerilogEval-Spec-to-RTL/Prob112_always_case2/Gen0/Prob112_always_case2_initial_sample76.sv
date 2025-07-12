module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*)
    begin
        if (in[3] == 1'b1) // Check most significant bit first
            pos = 2'b11;
        else if (in[2] == 1'b1)
            pos = 2'b11;
        else if (in[1] == 1'b1)
            pos = 2'b10;
        else if (in[0] == 1'b1)
            pos = 2'b01;
        else // If no '1' bits are found
            pos = 2'b00;
    end

endmodule