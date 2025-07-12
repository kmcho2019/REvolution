module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Single expression combining all possible shifts
    assign out = {in, in} >> (8 - ((ctrl[2] ? 4 : 0) + 
                                  (ctrl[1] ? 2 : 0) + 
                                  (ctrl[0] ? 1 : 0)));
endmodule