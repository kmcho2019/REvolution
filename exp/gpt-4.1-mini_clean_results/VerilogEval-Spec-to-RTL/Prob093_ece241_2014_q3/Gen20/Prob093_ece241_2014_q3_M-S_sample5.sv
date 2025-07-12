module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00 column): cd=00->0,01->0,11->0,10->1
    // First mux selects between rows cd=00 vs cd=01: both 0
    // Second mux selects between cd=11 vs cd=10: 0 and 1
    // Use c as selector between first mux (0) and second mux (d=1 if d=0 or 1)
    // Implement as mux c: if 0 then 0 else mux d: 0 or 1
    assign mux_in[0] = c ? (d ? 1'b0 : 1'b1) : 1'b0;

    // mux_in[1] (ab=01 column): all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11 column): cd=00->0,01->0,11->1,10->0
    // mux with c selector: c=0 output 0; c=1 output mux d (0 or 1)
    // d=0 ->0; d=1->1
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : 1'b0;

    // mux_in[3] (ab=10 column): cd=00->1,01->0,11->1,10->1
    // Use d as selector: d=0 output 1; d=1 output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule