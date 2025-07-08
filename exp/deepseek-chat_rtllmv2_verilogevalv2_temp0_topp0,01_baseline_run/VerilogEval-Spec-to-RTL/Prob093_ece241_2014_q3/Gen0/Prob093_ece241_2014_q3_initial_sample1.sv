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
    wire term1 = not_c & d;
    wire term2 = c & d;
    wire term3 = c & not_d;
    
    // First OR: term1 OR term2
    wire or1 = term1 | term2;
    // Final OR: or1 OR term3
    assign mux_in[0] = or1 | term3;

    // Implement mux_in[3] = (¬c∧¬d) ∨ (c∧d) ∨ (c∧¬d)
    wire term4 = not_c & not_d;
    wire term5 = c & d;  // same as term2
    wire term6 = c & not_d;  // same as term3
    
    // First OR: term4 OR term5
    wire or2 = term4 | term5;
    // Final OR: or2 OR term6
    assign mux_in[3] = or2 | term6;

endmodule