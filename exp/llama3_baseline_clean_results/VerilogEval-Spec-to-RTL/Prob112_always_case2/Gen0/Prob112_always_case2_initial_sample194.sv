module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        if (in[3]) pos = 2'b11; // MSB is set, so output is 3 (2'b11)
        else if (in[2]) pos = 2'b10; // second MSB is set, so output is 2 (2'b10)
        else if (in[1]) pos = 2'b01; // second LSB is set, so output is 1 (2'b01)
        else if (in[0]) pos = 2'b00; // LSB is set, so output is 0 (2'b00)
        else pos = 2'b00; // if none of the above conditions are true, output is 0
    end

endmodule