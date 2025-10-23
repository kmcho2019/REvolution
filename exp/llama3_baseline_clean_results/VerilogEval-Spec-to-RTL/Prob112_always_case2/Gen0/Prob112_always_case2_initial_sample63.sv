module TopModule(
    input  [3:0] in,
    output [1:0] pos
);
    always @(in) begin
        pos = 2'b00; // default output when no '1' bit is found
        if (in[3]) pos = 2'b11; // MSB set
        else if (in[2]) pos = 2'b10; // second MSB set
        else if (in[1]) pos = 2'b01; // second LSB set
        else if (in[0]) pos = 2'b01; // LSB set
    end
endmodule