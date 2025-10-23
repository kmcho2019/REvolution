module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(in) begin
    pos = 2'b00; // default output is 0
    if (in[3]) pos = 2'b11; // if MSB is 1, output 3
    else if (in[2]) pos = 2'b10; // if 2nd MSB is 1, output 2
    else if (in[1]) pos = 2'b01; // if 2nd LSB is 1, output 1
    else if (in[0]) pos = 2'b00; // if LSB is 1, output 0
end

endmodule