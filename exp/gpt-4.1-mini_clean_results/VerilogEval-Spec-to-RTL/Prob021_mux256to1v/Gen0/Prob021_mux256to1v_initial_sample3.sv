module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Shift input right by sel*4 and select the lowest 4 bits
    assign out = in >> (sel * 4);

endmodule