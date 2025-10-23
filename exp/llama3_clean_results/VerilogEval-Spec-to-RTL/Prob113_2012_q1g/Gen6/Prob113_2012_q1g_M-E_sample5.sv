module TopModule(
    input  [3:0] x,
    output       f
);

    reg [15:0] truth_table = 16'b10000000_00000000_00010001;
    assign f = truth_table[x];

endmodule