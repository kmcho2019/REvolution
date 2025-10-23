module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Mux_in[0] should be 0 when c=0 or d=0, and 1 when c=1 and d=1
    // This can be achieved by using a 2-to-1 mux with c as the selector
    // and 0 and d as the inputs
    assign mux_in[0] = (c) ? d : 0;

    // Mux_in[1] should be 1 when c=1 and d=0, and 0 otherwise
    // This can be achieved by using a 2-to-1 mux with c as the selector
    // and 0 and ~d as the inputs
    assign mux_in[1] = (c) ? ~d : 0;

    // Mux_in[2] should be 1 when c=1 and d=1, and 0 otherwise
    // This can be achieved by using a 2-to-1 mux with c as the selector
    // and 0 and d as the inputs
    assign mux_in[2] = (c) ? d : 0;

    // Mux_in[3] should be 1 when c=1 or d=1, and 0 when c=0 and d=0
    // This can be achieved by using a 2-to-1 mux with c as the selector
    // and d and 1 as the inputs
    assign mux_in[3] = (c) ? 1 : d;
endmodule