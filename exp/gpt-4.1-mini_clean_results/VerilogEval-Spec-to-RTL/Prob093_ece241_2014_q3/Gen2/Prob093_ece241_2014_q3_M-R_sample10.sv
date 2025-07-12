module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire not_d;

    // Invert d using continuous assignment (equivalent to mux2 inverter)
    assign not_d = ~d;

    // mux_in[0]: For ab=00 column in K-map:
    // Output 0 when cd=00 else 1
    // Expression: if c==0 then output d else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: For ab=01 column in K-map:
    // Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: For ab=11 column in K-map:
    // Output 1 only when c=1 and d=1
    // Expression: if c==0 then 0 else d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: For ab=10 column in K-map:
    // Output 1 when cd=00,10,11; 0 when cd=01
    // Expression: if c==0 output ~d else 1
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule