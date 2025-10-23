module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    wire [7:0] temp;
    assign temp = in;
    assign pos = (temp[0] ? 3'd0 :
                  temp[1] ? 3'd1 :
                  temp[2] ? 3'd2 :
                  temp[3] ? 3'd3 :
                  temp[4] ? 3'd4 :
                  temp[5] ? 3'd5 :
                  temp[6] ? 3'd6 :
                  temp[7] ? 3'd7 : 3'd0);

    // alternative implementation using bitwise operations
    // assign pos = $clog2(in);

endmodule