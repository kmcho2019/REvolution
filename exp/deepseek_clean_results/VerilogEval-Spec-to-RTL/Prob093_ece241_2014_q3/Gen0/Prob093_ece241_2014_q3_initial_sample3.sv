module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] is c AND d
    assign mux_in[2] = c & d;

    // Implement mux_in[0] = (¬c∧d) ∨ (c∧d) ∨ (c∧¬d)
    wire not_c = ~c;
    wire not_d = ~d;
    wire term0 = not_c & d;
    wire term1 = c & d;
    wire term2 = c & not_d;
    
    // First OR: term0 OR term1
    wire or0 = term0 | term1;
    // Final OR: or0 OR term2
    assign mux_in[0] = or0 | term2;

    // Implement mux_in[3] = (¬c∧¬d) ∨ (c∧d) ∨ (c∧¬d)
    wire term3 = not_c & not_d;
    wire term4 = c & d;  // same as term1
    wire term5 = c & not_d;  // same as term2
    
    // First OR: term3 OR term4
    wire or1 = term3 | term4;
    // Final OR: or1 OR term5
    assign mux_in[3] = or1 | term5;

endmodule