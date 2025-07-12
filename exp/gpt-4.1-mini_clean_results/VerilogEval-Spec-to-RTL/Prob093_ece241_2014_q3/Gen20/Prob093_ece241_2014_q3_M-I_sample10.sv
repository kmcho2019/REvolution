module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00:
    // if c=0 => output = d
    // if c=1 => output = 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11:
    // if c=0 => output = 0
    // if c=1 => output = d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10:
    // if d=0 => output = 1
    // if d=1 => output = c
    assign mux_in[3] = d ? c : 1'b1;

endmodule