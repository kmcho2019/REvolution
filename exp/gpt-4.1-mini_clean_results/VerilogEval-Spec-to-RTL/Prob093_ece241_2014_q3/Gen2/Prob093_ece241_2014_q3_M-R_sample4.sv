module TopModule(input c, input d, output [3:0] mux_in);
    // Invert d using mux realized by ternary operator (2-to-1 mux)
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] corresponds to ab=00:
    // Function: output 0 only when c=0,d=0, else 1
    // Equivalent to mux2 with select=c:
    // if c==0 output d else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] corresponds to ab=01:
    // Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] corresponds to ab=11:
    // Output 1 only when c=1,d=1, else 0
    // mux2 with select c: if c==0 output 0 else d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] corresponds to ab=10:
    // Output 1 except when c=0,d=1, then 0
    // if c==0 output ~d else 1
    assign mux_in[3] = c ? 1'b1 : not_d;
endmodule