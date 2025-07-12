module mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);
    // Implement mux_in[0] for ab=00
    // K-map values: cd=00:0,01:1,11:1,10:1
    // out = c + d = c ? 1 : d
    wire mux0_d;
    mux2to1 u0d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_d)); // mux0_d = d
    wire mux0;
    mux2to1 u0c (.sel(c), .in0(mux0_d), .in1(1'b1), .out(mux0));  // mux0 = c?1:d

    // Implement mux_in[1] for ab=01
    // K-map all zeros
    wire mux1 = 1'b0;

    // Implement mux_in[2] for ab=11
    // K-map cd: 00=0,01=0,11=1,10=0
    // out = c & d = d ? c : 0
    wire mux2;
    mux2to1 u2d (.sel(d), .in0(1'b0), .in1(c), .out(mux2));

    // Implement mux_in[3] for ab=10
    // K-map: 00=1,01=0,11=1,10=1
    // out = c ? 1 : ~d
    // ~d = d ? 0 : 1
    wire not_d;
    mux2to1 u_notd (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    wire mux3;
    mux2to1 u3c (.sel(c), .in0(not_d), .in1(1'b1), .out(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule