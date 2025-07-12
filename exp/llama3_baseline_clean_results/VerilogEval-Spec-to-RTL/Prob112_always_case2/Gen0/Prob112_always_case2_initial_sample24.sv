module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        pos = 2'b00; // default output to 0
        if (in[3]) pos = 2'b11; // bit 3 is the most significant, output 3
        else if (in[2]) pos = 2'b10; // bit 2 is the next most significant, output 2
        else if (in[1]) pos = 2'b01; // bit 1 is the next most significant, output 1
        else if (in[0]) pos = 2'b00; // bit 0 is the least significant, output 0
    end

endmodule