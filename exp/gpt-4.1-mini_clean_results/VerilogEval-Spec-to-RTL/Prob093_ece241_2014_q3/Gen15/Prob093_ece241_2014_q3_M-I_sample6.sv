module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // ab=00 column: mux_in[0]
    // If c=1 output 1 else output d
    assign mux_in[0] = c ? 1'b1 : d;

    // ab=01 column: mux_in[1]
    // Always 0
    assign mux_in[1] = 1'b0;

    // ab=11 column: mux_in[2]
    // If c=1 output d else 0
    assign mux_in[2] = c ? d : 1'b0;

    // ab=10 column: mux_in[3]
    // If d=1 output c else 1
    assign mux_in[3] = d ? c : 1'b1;
endmodule