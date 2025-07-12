module TopModule (
    input [99:0] a,  // 100-bit input
    input [99:0] b,  // 100-bit input
    input sel,      // Select signal
    output [99:0] out // 100-bit output
);

// Using ternary operator for concise representation
assign out = sel ? b : a;

endmodule