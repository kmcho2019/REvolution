module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab = 00 cases:
    // cd=00:0, cd=01:1, cd=11:1, cd=10:1 → simply d covers all required 1s
    assign mux_in[0] = d;
    
    // ab = 01 cases: always 0 (all entries in column are 0)
    assign mux_in[1] = 1'b0;
    
    // ab = 11 cases: only cd=11 is 1 → c AND d
    assign mux_in[2] = c & d;
    
    // ab = 10 cases:
    // cd=00:1, cd=01:0, cd=11:1, cd=10:1 → ~d OR (c AND d)
    assign mux_in[3] = ~d | (c & d);

endmodule