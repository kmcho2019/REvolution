module mux2to1 (input sel, input d0, input d1, output y);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire not_d;
    wire and_cd;
    wire mux0;
    wire zero = 1'b0;

    // not_d = ~d
    // Implement ~d with mux: select d, output 1 if d=0 else 0
    mux2to1 not_d_mux(.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));

    // and_cd = c & d
    // Implement c & d with mux: select c, if c=0 then 0 else d
    mux2to1 and_mux(.sel(c), .d0(1'b0), .d1(d), .y(and_cd));

    // mux_in[0] = 1 if cd != 00 else 0
    // cd=00 => c=0,d=0 => 0 else 1
    // Implement with muxes:
    // First: mux2to1 with sel=c, if c=0 then mux(d,0,1), else 1
    wire mux0_dsel;
    mux2to1 mux0_dmux(.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_dsel));
    mux2to1 mux0_csel(.sel(c), .d0(mux0_dsel), .d1(1'b1), .y(mux0));
    
    // mux_in[1] = 0
    assign mux_in[1] = zero;

    // mux_in[2] = c & d = and_cd
    assign mux_in[2] = and_cd;

    // mux_in[3] = c | ~d
    // Implement with mux c: if c=1 then 1 else not_d
    wire mux3;
    mux2to1 mux3_csel(.sel(c), .d0(not_d), .d1(1'b1), .y(mux3));
    
    assign mux_in[0] = mux0;
    assign mux_in[3] = mux3;

endmodule