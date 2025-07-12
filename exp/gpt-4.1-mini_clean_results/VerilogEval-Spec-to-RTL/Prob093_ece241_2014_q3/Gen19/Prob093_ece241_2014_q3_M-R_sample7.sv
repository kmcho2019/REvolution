module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // 2-to-1 mux function for clarity
    // sel=0 -> output in0, sel=1 -> output in1
    // Use assign with ternary operator to model mux
    wire mux2to1_0, mux2to1_1, mux2to1_2, mux2to1_3;

    // mux_in[0] for ab=00
    // K-map cd: 00->0,01->1,11->1,10->1
    // Implemented as mux with selector c:
    // c=0 select d; c=1 select 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01
    // K-map column all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11
    // cd: 00->0,01->0,11->1,10->0
    // Use c as selector: if c=0 output 0 else output d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10
    // cd: 00->1,01->0,11->1,10->1
    // Use d as selector: d=0 output 1, d=1 output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule