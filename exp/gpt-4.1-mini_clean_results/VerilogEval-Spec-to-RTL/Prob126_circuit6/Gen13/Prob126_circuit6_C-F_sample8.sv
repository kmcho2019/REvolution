module TopModule(
    input  [2:0] a,
    output [15:0] q
);

    // ROM initialized as localparam for efficient, constant combinational lookup
    localparam [15:0] rom [0:7] = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Assign output directly from ROM indexed by input a
    assign q = rom[a];

endmodule