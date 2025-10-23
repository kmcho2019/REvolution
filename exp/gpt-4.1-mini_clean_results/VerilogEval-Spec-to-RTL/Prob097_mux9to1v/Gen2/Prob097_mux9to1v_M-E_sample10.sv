module mux3to1_16bit(
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel, // selects 0,1,2
    output [15:0] out
);
    // For each bit, select according to sel (2 bits, but max 2 used)
    // If sel >=3, output zero (though in this design sel max 2)
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 : 16'd0;
endmodule

module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    wire [15:0] group0, group1, group2;
    wire [15:0] final_mux_out;

    // First-level muxes (3-to-1)
    mux3to1_16bit mux_group0(.in0(a), .in1(b), .in2(c), .sel(sel[1:0]), .out(group0));
    mux3to1_16bit mux_group1(.in0(d), .in1(e), .in2(f), .sel(sel[1:0]), .out(group1));
    mux3to1_16bit mux_group2(.in0(g), .in1(h), .in2(i), .sel(sel[1:0]), .out(group2));

    // Second-level mux (3-to-1) selects among groups based on sel[3:2]
    mux3to1_16bit mux_final(.in0(group0), .in1(group1), .in2(group2), .sel(sel[3:2]), .out(final_mux_out));

    // Detect invalid sel (sel > 8)
    wire invalid_sel = (sel > 4'd8);

    assign out = invalid_sel ? 16'hFFFF : final_mux_out;

endmodule