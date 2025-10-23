module TopModule (
    input  [3:0] x,
    output      f
);

    // LUT from Karnaugh map with rows=x[3]x[0], cols=x[1]x[2]
    // LUT bits correspond to f({x[3],x[0],x[1],x[2]})

    localparam [15:0] lut = 16'h3380;

    // Form address from input bits:
    // addr = {x[3], x[0], x[1], x[2]}
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};

    assign f = lut[addr];

endmodule