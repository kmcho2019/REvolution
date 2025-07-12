module TopModule(
    input  [3:0] x, // x = {x4,x3,x2,x1} = {x[3],x[2],x[1],x[0]}
    output      f
);

    // LUT from original Karnaugh map with chosen don't-cares
    localparam [15:0] LUT = 16'h3340;

    // Reorder input bits from x={x4,x3,x2,x1} to index as {x3,x4,x1,x2}
    wire [3:0] idx;
    assign idx = {x[2], x[3], x[0], x[1]};

    assign f = LUT[idx];

endmodule