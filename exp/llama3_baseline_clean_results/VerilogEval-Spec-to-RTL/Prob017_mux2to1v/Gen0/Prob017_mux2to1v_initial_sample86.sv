module TopModule(
    input [99:0] a,  // 100-bit input signal 'a'
    input [99:0] b,  // 100-bit input signal 'b'
    input sel,       // Select signal for the multiplexer
    output [99:0] out  // 100-bit output signal 'out'
);

assign out = (sel == 1'b1)? b : a;  // Ternary operator to select between 'a' and 'b' based on 'sel'

endmodule