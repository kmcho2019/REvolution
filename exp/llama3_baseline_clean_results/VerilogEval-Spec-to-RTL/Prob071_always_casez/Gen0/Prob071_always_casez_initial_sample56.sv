module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 0;
        if (in[0]) pos = 1;
        else if (in[1]) pos = 2;
        else if (in[2]) pos = 3;
        else if (in[3]) pos = 4;
        else if (in[4]) pos = 5;
        else if (in[5]) pos = 6;
        else if (in[6]) pos = 7;
        else if (in[7]) pos = 8;
    end

endmodule