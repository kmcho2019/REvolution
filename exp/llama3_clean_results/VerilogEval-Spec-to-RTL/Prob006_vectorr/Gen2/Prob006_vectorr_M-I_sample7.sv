module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// Alternatively, a more compact and efficient way to reverse bits in Verilog
// assign out = in[7:0]; // No change needed, just an example of compact notation

// However, for reversing, we can also use a loop in a generate block or an always block for larger vectors
// But for an 8-bit vector, the above method is sufficient and simple.

endmodule