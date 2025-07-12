module TopModule(
    input [99:0] in,  // 100 bits
    output [99:0] out  // 100 bits
);

assign out = in[99:0]; // This is a simple and concise way to reverse the bits

// Alternatively, you could also use:
// assign out = {>>{in}}; // This is another way to reverse the bits in Verilog

endmodule