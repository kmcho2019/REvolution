module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00 (mux_in[0]) cd={d,c}
    assign mux_in[0] = c ? 1'b1 : d;

    // For ab=01 (mux_in[1]) all zeros
    assign mux_in[1] = 1'b0;

    // For ab=11 (mux_in[2])
    assign mux_in[2] = c ? d : 1'b0;

    // For ab=10 (mux_in[3]) corrected as per cd={d,c}
    assign mux_in[3] = d ? 1'b1 : c;
endmodule