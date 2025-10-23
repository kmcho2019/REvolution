module TopModule(
    input  [3:0] x,
    output      f
);

    // Function LUT: bit index = {x[3], x[2], x[1], x[0]}
    // 16'hD703 corresponds to the Karnaugh map given.
    wire [15:0] LUT = 16'hD703;

    assign f = LUT[x];

endmodule