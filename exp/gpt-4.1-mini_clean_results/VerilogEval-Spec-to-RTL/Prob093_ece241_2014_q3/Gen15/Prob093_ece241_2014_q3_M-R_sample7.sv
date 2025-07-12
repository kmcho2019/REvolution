module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // ab=00: for cd=00,01,11,10 => 0,1,1,1 
    // express as: if c=0, output d else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // ab=01: all zeros
    assign mux_in[1] = 1'b0;

    // ab=11: cd=00,01,11,10 -> 0,0,1,0 
    // express as: if c=0 output 0 else d
    assign mux_in[2] = c ? d : 1'b0;

    // ab=10: cd=00,01,11,10 -> 1,0,1,1
    // originally: c ? 1 : ~d
    // refactor ~d as (d ? 0 : 1) using mux only
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);
endmodule