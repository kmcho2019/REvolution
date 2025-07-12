module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00 column):  
    // From K-map: 0 (c=0,d=0), 1 (c=0,d=1), 1 (c=1,d=1), 1 (c=1,d=0)
    // Implemented as a 2-to-1 mux with selector c:
    // if c=0 output d else output 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] (ab=01 column):
    // Always 0 in K-map, so constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11 column):
    // From K-map: 0 (c=0,d=0),0 (c=0,d=1),1 (c=1,d=1),0 (c=1,d=0)
    // Implemented as 2-to-1 mux with selector d:
    // if d=0 output 0 else output c
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] (ab=10 column):
    // From K-map: 1 (c=0,d=0), 0 (c=0,d=1), 1 (c=1,d=1), 1 (c=1,d=0)
    // Implemented as 2-to-1 mux with selector d:
    // if d=0 output 1 else output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule