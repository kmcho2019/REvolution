module mux2(
    input  sel,
    input  d0,
    input  d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire not_d;

    // Invert d by mux2: select=d, output is 1 if d=0 else 0
    mux2 inv_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));

    // mux_in[0]: function for ab=00 column in K-map
    // 0 when cd=00, else 1
    // Implement as mux2 with select=c:
    // if c=0 output d, else output 1
    mux2 mi0 (.sel(c), .d0(d), .d1(1'b1), .y(mux_in[0]));

    // mux_in[1]: function for ab=01 column, always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: function for ab=11 column
    // Only 1 when c=1 and d=1, else 0
    // mux2 select=c:
    // if c=0 output 0, else output d
    mux2 mi2 (.sel(c), .d0(1'b0), .d1(d), .y(mux_in[2]));

    // mux_in[3]: function for ab=10 column
    // 1 when cd=00,10,11; 0 when cd=01
    // mux2 select=c:
    // if c=0 output ~d, else output 1
    mux2 mi3 (.sel(c), .d0(not_d), .d1(1'b1), .y(mux_in[3]));
endmodule