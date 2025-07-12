module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Using nested multiplexers to implement each bit of mux_in

    // mux_in[0]:  c ? 1 : d  => f = c ? (d ? 1 : 1) : (d ? 1 : 0)
    // But from K-map: 
    // c=0, d=0 => 0
    // c=0, d=1 => 1
    // c=1, d=0 => 1
    // c=1, d=1 => 1
    // So:
    // For c=0: d ? 1 : 0
    // For c=1: 1
    assign mux_in[0] = c ? 1'b1 : (d ? 1'b1 : 1'b0);

    // mux_in[1]: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c ? d : 0
    // For c=0: 0
    // For c=1: d
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : 1'b0;

    // mux_in[3]: For c=0: d=0->1, d=1->0
    //            For c=1: 1
    // i.e. mux_in[3] = c ? 1 : (d ? 0 : 1)
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule