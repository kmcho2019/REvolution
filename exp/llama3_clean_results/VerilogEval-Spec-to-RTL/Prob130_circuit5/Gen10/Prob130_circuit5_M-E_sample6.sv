module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire enable_b, enable_e, enable_a, enable_d;

// Create a decoder to generate enable signals
assign enable_b = (c == 4'b0000);
assign enable_e = (c == 4'b0001);
assign enable_a = (c == 4'b0010);
assign enable_d = (c == 4'b0011);

// Use the enable signals to selectively pass through the desired input
assign q = (enable_b) ? b : 
           (enable_e) ? e : 
           (enable_a) ? a : 
           (enable_d) ? d : 4'b1111;  // 'f' is represented as 4'b1111

endmodule