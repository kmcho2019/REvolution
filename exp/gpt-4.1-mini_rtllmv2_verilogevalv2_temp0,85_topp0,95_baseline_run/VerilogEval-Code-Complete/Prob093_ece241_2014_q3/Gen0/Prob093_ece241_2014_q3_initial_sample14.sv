module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    wire not_d;
    wire f0, f2, f3;

    // not_d = ~d implemented as mux: if d=0 output 1 else 0
    assign not_d = (d) ? 0 : 1; // MUX(d,1,0)

    // f0 = mux c { d , 1 }
    assign f0 = (c) ? 1 : d;

    // f1 = 0
    // assign mux_in[1] = 0 later

    // f3 = mux c { 0 , d }
    assign f3 = (c) ? d : 0;

    // f2 = mux c { 1 , not_d }
    assign f2 = (c) ? not_d : 1;

    assign mux_in[0] = f0;
    assign mux_in[1] = 1'b0;
    assign mux_in[3] = f3;
    assign mux_in[2] = f2;

endmodule