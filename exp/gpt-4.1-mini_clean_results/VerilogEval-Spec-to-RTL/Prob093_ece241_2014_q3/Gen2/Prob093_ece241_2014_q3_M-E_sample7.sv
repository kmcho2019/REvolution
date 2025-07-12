module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Define a 2-to-1 mux function: sel ? in1 : in0
    // Use this pattern repeatedly for clarity
    
    // Implement not_d = mux(d, 1, 0)
    wire not_d = d ? 1'b0 : 1'b1;

    // From K-map, each mux_in[i] corresponds to a fixed (a,b) input:
    // ab=00 -> mux_in[0] : function f0(c,d)
    // ab=01 -> mux_in[1] : function f1(c,d)
    // ab=11 -> mux_in[2] : function f2(c,d)
    // ab=10 -> mux_in[3] : function f3(c,d)

    // We implement each f_i(c,d) only using 2-to-1 muxes.

    // f0: corresponds to ab=00 column in K-map
    // K-map column 00: rows cd = 00,01,11,10 values are: 0,1,1,1
    // So f0 = d==0 ? 0 : c ? 1 : 1  (analyzed as below)
    // More simply:
    // cd=00 =>0
    // cd=01 =>1
    // cd=10 =>1
    // cd=11 =>1
    // We can write f0 as mux(c, mux(d,0,1), 1)
    // That is, first mux over d (sel=d): if d=0 ->0 else 1
    // Then mux over c: if c=0 -> above mux result, else 1
    wire f0_d_mux = d ? 1'b1 : 1'b0;
    wire f0 = c ? 1'b1 : f0_d_mux;

    // f1: ab=01
    // Values: 0,0,0,0 all zeros
    wire f1 = 1'b0;

    // f2: ab=11
    // Values: 0,0,1,0 for cd=00,01,11,10 respectively
    // f2(d,c) = when cd=11 output=1 else 0 except cd=00=0, 01=0, 10=0
    // So f2= (c&d)
    // We must implement with muxes only:
    // f2 = mux(c, mux(d,0,1), 0)
    // For c=0 ->0
    // For c=1 -> if d=0 ->0 else 1
    wire f2_d_mux = d ? 1'b1 : 1'b0;
    wire f2 = c ? f2_d_mux : 1'b0;

    // f3: ab=10
    // Values: 1,0,1,1 for cd=00,01,11,10 respectively
    // Let's analyze f3(c,d):
    // cd=00 (c=0,d=0) =>1
    // cd=01 (c=0,d=1) =>0
    // cd=11 (c=1,d=1) =>1
    // cd=10 (c=1,d=0) =>1
    //
    // Implement f3 = mux(c, mux(d,1,1), mux(d,0,1))
    // For c=0: f3 = mux(d,0,1)
    // For c=1: f3 = mux(d,1,1) = always 1
    wire f3_c1 = d ? 1'b1 : 1'b1;  // always 1
    wire f3_c0 = d ? 1'b0 : 1'b1;
    wire f3 = c ? f3_c1 : f3_c0;

    assign mux_in = {f3, f2, f1, f0};
endmodule