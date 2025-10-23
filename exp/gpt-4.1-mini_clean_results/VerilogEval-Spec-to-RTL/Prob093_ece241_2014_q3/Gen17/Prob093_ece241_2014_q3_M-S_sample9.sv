module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00
    assign mux_in[0] = c ? 1'b1 : d;

    // For ab=01
    assign mux_in[1] = 1'b0;

    // For ab=11
    assign mux_in[2] = c ? d : 1'b0;

    // For ab=10
    assign mux_in[3] = d ? c : 1'b1;
endmodule