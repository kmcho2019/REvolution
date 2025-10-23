module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00 column: output 0 at cd=00, else 1 except at cd=01 which is 1
    // Implement as: if c=0 output d else 1
    // cd=00: c=0,d=0 => 0; cd=01: c=0,d=1 =>1; cd=10 or 11 c=1 =>1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01 column: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11 column: output 1 only at cd=11, else 0
    // Implement as: if d=1 output c else 0
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] for ab=10 column: outputs 1 at cd=00,10,11 and 0 at cd=01
    // Implement as: if d=0 output 1 else c
    assign mux_in[3] = d ? c : 1'b1;

endmodule