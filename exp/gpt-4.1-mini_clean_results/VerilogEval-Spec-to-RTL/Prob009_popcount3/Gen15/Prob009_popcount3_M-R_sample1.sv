module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Count number of '1's by summing each bit after AND with 1'b1
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule