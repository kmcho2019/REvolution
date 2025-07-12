module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Using a 2-to-1 multiplexer to implement the logic
// The selection lines (s) are driven by 'b' and 'c', and the data lines (d0, d1) are set based on 'a'
// When 'b' and 'c' are both 0, 'out' should be 'a'
// For other combinations of 'b' and 'c', 'out' should be 1 if 'a' is 1 or if either 'b' or 'c' is 1
assign out = (b | c) ? (a | b | c) : a;

// Alternatively, explicitly using a multiplexer (though Verilog's conditional operator serves the purpose here)
// assign out = (b == 0 && c == 0) ? a : (a | b | c);

endmodule