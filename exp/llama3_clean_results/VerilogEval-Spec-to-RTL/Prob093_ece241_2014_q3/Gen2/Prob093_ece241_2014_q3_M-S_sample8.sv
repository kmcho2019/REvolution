module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = (c == 0 && d == 0)? 0 : (c == 0 && d == 1)? 1 : (c == 1 && d == 0)? 0 : (c == 1 && d == 1)? 1 : 0;
    assign mux_in[1] = 0;
    assign mux_in[2] = (c == 0 && d == 0)? 0 : (c == 0 && d == 1)? 0 : (c == 1 && d == 0)? 0 : (c == 1 && d == 1)? 1 : 0;
    assign mux_in[3] = (c == 0 && d == 0)? 1 : (c == 0 && d == 1)? 0 : (c == 1 && d == 0)? 1 : (c == 1 && d == 1)? 1 : 0;

endmodule