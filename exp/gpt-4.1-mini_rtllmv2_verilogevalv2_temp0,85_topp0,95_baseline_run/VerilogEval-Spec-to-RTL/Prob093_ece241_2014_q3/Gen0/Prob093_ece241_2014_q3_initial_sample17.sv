module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_c, not_d;
    wire not_c_and_not_d;
    
    // NOT c = MUX(c,0,1)
    mux2to1 not_c_mux (
        .sel(c),
        .in0(1'b0),
        .in1(1'b1),
        .out(not_c)
    );
    
    // NOT d = MUX(d,0,1)
    mux2to1 not_d_mux (
        .sel(d),
        .in0(1'b0),
        .in1(1'b1),
        .out(not_d)
    );
    
    // AND NOT c and NOT d = MUX(not_d,0,not_c)
    mux2to1 and_notc_notd_mux (
        .sel(not_c),
        .in0(1'b0),
        .in1(not_d),
        .out(not_c_and_not_d)
    );
    
    // OR c,d = MUX(d,1,c) => mux_in[0]
    mux2to1 or_c_d_mux (
        .sel(c),
        .in0(d),
        .in1(1'b1),
        .out(mux_in[0])
    );
    
    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;
    
    // AND c,d = MUX(d,0,c) => mux_in[2]
    mux2to1 and_c_d_mux (
        .sel(c),
        .in0(1'b0),
        .in1(d),
        .out(mux_in[2])
    );
    
    // OR c, (NOT c AND NOT d) = MUX((~c & ~d),1,c) => mux_in[3]
    mux2to1 or_c_andnotcnotd_mux (
        .sel(c),
        .in0(not_c_and_not_d),
        .in1(1'b1),
        .out(mux_in[3])
    );

endmodule

// 2-to-1 Multiplexer module
module mux2to1(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule