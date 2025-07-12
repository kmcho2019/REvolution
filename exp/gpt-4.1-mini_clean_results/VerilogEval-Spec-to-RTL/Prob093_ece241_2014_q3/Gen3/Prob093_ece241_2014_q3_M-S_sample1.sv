module mux2to1 (
    input wire sel,
    input wire in0,
    input wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);
    // Implement mux_in[0] for ab=00:
    // K-map cd values: 00=0,01=1,11=1,10=1
    // Truth table:
    // c d | out
    // 0 0 | 0
    // 0 1 | 1
    // 1 0 | 1
    // 1 1 | 1
    // out = c + d (OR)
    // Use mux form: out = c ? 1 : d
    wire mux0_d;
    mux2to1 u0d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_d)); // mux0_d = d
    wire mux0;
    mux2to1 u0c (.sel(c), .in0(mux0_d), .in1(1'b1), .out(mux0));  // mux0 = c?1:d

    // mux_in[1] for ab=01:
    // K-map all zeros => assign 0 directly
    wire mux1 = 1'b0;

    // mux_in[2] for ab=11:
    // cd K-map: 00=0,01=0,11=1,10=0
    // out = c & d
    // mux with d as selector: out = d ? c : 0
    wire mux2;
    mux2to1 u2d (.sel(d), .in0(1'b0), .in1(c), .out(mux2));

    // mux_in[3] for ab=10:
    // cd K-map: 00=1,01=0,11=1,10=1
    // Truth table:
    // c d | out
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 1
    // 1 1 | 1
    // When c=0: out = ~d
    // When c=1: out = 1
    // Implement ~d by mux with d selector: ~d = d?0:1
    wire not_d;
    mux2to1 u_notd (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    wire mux3;
    mux2to1 u3c (.sel(c), .in0(not_d), .in1(1'b1), .out(mux3));

    // Output mux_in vector (ab=00->mux_in[0], ab=01->mux_in[1], ab=11->mux_in[2], ab=10->mux_in[3])
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule