module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        if (in[3]) pos = 2'b10;  // if MSB is 1, output 2
        else if (in[2]) pos = 2'b01;  // if 2nd MSB is 1, output 1
        else if (in[1]) pos = 2'b00;  // if 2nd LSB is 1, output 0 (assuming 0-indexed)
        else if (in[0]) pos = 2'b11;  // if LSB is 1, output 3
        else pos = 2'b00;  // if none of the above conditions are met, output 0
    end

endmodule