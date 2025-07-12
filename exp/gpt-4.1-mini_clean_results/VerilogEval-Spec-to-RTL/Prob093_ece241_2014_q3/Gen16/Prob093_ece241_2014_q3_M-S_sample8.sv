module mux2 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // From the K-map:
    // For ab=00 (mux_in[0]):
    // cd=00=0,01=0,11=0,10=1
    // Output = (~c & ~d &0) + (~c & d &0) + (c & d &0) + (c & ~d &1)
    // Simplifies to mux with sel=d, in0=0, in1=1, then sel=c selects between 0 and the mux result
    // Here it's simpler to set:
    // mux_in[0] = (~c) ? 0 : (~d ? 1 : 0)
    // Implement as mux with sel=d: in0=1, in1=0 → tmp0 = d ? 0 :1
    // Then mux with sel=c: in0=0, in1=tmp0
    wire tmp0;
    mux2 mux0_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(tmp0));
    mux2 mux0_c (.sel(c), .in0(1'b0), .in1(tmp0), .out(mux_in[0]));

    // For ab=01 (mux_in[1]):
    // cd=00=1,01=0,11=0,10=0
    // Output = (~c & ~d &1) + (~c & d &0) + (c & d &0) + (c & ~d &0)
    // So output is 1 only when c=0 and d=0, else 0
    // mux_in[1] = ~c & ~d
    // Implement as mux with sel=d: in0=1, in1=0 → tmp1 = d ? 0 :1
    // Then mux with sel=c: in0=tmp1, in1=0
    wire tmp1;
    mux2 mux1_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(tmp1));
    mux2 mux1_c (.sel(c), .in0(tmp1), .in1(1'b0), .out(mux_in[1]));

    // For ab=11 (mux_in[2]):
    // cd=00=0,01=0,11=1,10=0
    // Output= 1 only when c=1 and d=1, else 0
    // mux_in[2] = c & d
    // Implement as mux with sel=d: in0=0, in1=1 → tmp2 = d ? 1 : 0
    // Then mux with sel=c: in0=0, in1=tmp2
    wire tmp2;
    mux2 mux2_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(tmp2));
    mux2 mux2_c (.sel(c), .in0(1'b0), .in1(tmp2), .out(mux_in[2]));

    // For ab=10 (mux_in[3]):
    // cd=00=1,01=0,11=1,10=1
    // Output=1 when c=0,d=0 or c=1,d=0 or c=1,d=1; only 0 when c=0,d=1
    // That is, mux_in[3] = ~d | c
    // Implement mux with sel=d: in0=1, in1=c
    mux2 mux3_d (.sel(d), .in0(1'b1), .in1(c), .out(mux_in[3]));
endmodule