module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[3]: ab=10 → 1,0,1,1 for cd=00,01,11,10
    wire mux_in_3 = d ? c : 1'b1;
    
    // mux_in[2]: ab=11 → 0,0,1,0 → c & d
    wire mux_in_2 = c & d;
    
    // mux_in[1]: ab=01 → always 0
    wire mux_in_1 = 1'b0;
    
    // mux_in[0]: ab=00 → 0,1,1,1 → c | d
    wire mux_in_0 = c | d;

    assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};

endmodule