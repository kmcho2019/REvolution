module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Combined two-stage mux with direct bit selection
    assign out = in[({sel[7:4], sel[3:0]} * 4) +: 4];

endmodule