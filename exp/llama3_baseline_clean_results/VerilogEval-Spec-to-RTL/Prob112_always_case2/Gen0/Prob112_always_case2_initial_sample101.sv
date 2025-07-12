module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) pos = 2'b11;  // Most significant bit has highest priority
        else if (in[2]) pos = 2'b10;
        else if (in[1]) pos = 2'b01;
        else if (in[0]) pos = 2'b00;
        else pos = 2'b00;  // If no '1' bits are found, output 0
    end

endmodule