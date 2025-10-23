module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Constants for clarity
    wire zero = 1'b0;
    wire one  = 1'b1;

    // mux_in[0], ab=00:
    // K-map (cd): 00=0, 01=1, 11=1, 10=1
    // Expression: if c=0 then output=d else 1
    // Implement as:
    // low_c = mux2to1(sel=d, d0=0, d1=1)
    wire low_c0;
    mux2to1 u0_d(.sel(d), .d0(zero), .d1(one), .y(low_c0));
    // mux_in[0] = mux2to1(sel=c, d0=low_c0, d1=one)
    mux2to1 u0_c(.sel(c), .d0(low_c0), .d1(one), .y(mux_in[0]));

    // mux_in[1], ab=01:
    // K-map: all zeros, so constant 0
    assign mux_in[1] = zero;

    // mux_in[2], ab=11:
    // K-map (cd): 00=0, 01=0, 11=1, 10=0
    // Expression: output = c & d
    // Implement as mux2to1 with c as selector:
    // For c=0 -> 0
    // For c=1 -> d
    mux2to1 u2_c(.sel(c), .d0(zero), .d1(d), .y(mux_in[2]));

    // mux_in[3], ab=10:
    // K-map (cd): 00=1, 01=0, 11=1, 10=1
    // Expression: 
    // For c=0: output = ~d (since d=0 ->1, d=1 ->0)
    // For c=1: output = 1
    wire not_d;
    assign not_d = ~d;
    mux2to1 u3_c0(.sel(d), .d0(one), .d1(zero), .y(/*unused, for clarity only*/));
    // Using assign for not_d is simpler
    mux2to1 u3_c(.sel(c), .d0(not_d), .d1(one), .y(mux_in[3]));

endmodule