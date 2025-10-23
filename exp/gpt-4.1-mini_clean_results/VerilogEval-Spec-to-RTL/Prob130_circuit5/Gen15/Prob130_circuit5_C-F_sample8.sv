module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire c_lt4 = (c < 4);
    wire [1:0] sel = c[1:0];

    // 4-to-1 multiplexer for c in [0..3]
    wire [3:0] mux_out = (sel == 2'd0) ? b :
                         (sel == 2'd1) ? e :
                         (sel == 2'd2) ? a :
                         d;

    assign q = c_lt4 ? mux_out : 4'hF;

endmodule