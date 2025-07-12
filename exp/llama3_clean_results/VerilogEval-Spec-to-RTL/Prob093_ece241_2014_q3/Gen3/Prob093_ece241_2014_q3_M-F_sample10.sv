module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c || d;  // '1' when 'cd' is '01', '10', or '11'
    assign mux_in[1] = 0;       // Always '0'
    assign mux_in[2] = c;       // '1' when 'c' is '1' (covers '10' and '11' when d=1 or d=0)
    assign mux_in[3] = c && d;  // '1' when 'cd' is '11'

endmodule