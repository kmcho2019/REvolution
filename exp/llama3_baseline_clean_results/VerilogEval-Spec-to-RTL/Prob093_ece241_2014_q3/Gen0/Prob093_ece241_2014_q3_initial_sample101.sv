module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 'd' when 'cd' equals 10 or 11, otherwise 0
    // For ab = 01, output is 'c' when 'cd' equals 10 or 11, otherwise 0
    // For ab = 11, output is 'd' when 'cd' equals 10 or 11, otherwise 0
    // For ab = 10, output is 'c' when 'cd' equals 10 or 11, otherwise 1
    assign mux_in[0] = (c && d) ? d : (~c && ~d) ? 0 : (~c && d) ? 1 : d;
    assign mux_in[1] = (c && d) ? c : (~c && ~d) ? 0 : (~c && d) ? 0 : 0;
    assign mux_in[2] = (c && d) ? d : (~c && ~d) ? 0 : (~c && d) ? 0 : d;
    assign mux_in[3] = (c && d) ? c : (~c && ~d) ? 1 : (~c && d) ? 1 : c;
endmodule