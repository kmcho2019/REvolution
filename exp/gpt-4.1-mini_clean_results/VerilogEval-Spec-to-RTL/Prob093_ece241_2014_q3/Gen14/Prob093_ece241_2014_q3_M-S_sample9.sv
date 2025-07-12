module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    assign mux_in[0] = c ? 1'b1 : d;    // ab=00
    assign mux_in[1] = 1'b0;            // ab=01
    assign mux_in[2] = c ? d : 1'b0;    // ab=11
    assign mux_in[3] = c ? 1'b1 : ~d;   // ab=10
endmodule