module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [9:0] comparators;

    always @(*) begin
        comparators[0] = (code == 8'h45);
        comparators[1] = (code == 8'h16);
        comparators[2] = (code == 8'h1e);
        comparators[3] = (code == 8'h26);
        comparators[4] = (code == 8'h25);
        comparators[5] = (code == 8'h2e);
        comparators[6] = (code == 8'h36);
        comparators[7] = (code == 8'h3d);
        comparators[8] = (code == 8'h3e);
        comparators[9] = (code == 8'h46);

        valid = (comparators!= 10'b0);
        out = 4'b0;
        if (comparators[0]) out = 4'd0;
        else if (comparators[1]) out = 4'd1;
        else if (comparators[2]) out = 4'd2;
        else if (comparators[3]) out = 4'd3;
        else if (comparators[4]) out = 4'd4;
        else if (comparators[5]) out = 4'd5;
        else if (comparators[6]) out = 4'd6;
        else if (comparators[7]) out = 4'd7;
        else if (comparators[8]) out = 4'd8;
        else if (comparators[9]) out = 4'd9;
    end

endmodule