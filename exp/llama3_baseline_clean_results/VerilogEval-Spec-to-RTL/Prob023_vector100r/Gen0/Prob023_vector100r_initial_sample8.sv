module TopModule(
    input  [99:0] in,
    output [99:0] out
);

assign out = {<<{100}{in}};  // Reverse the 100 bits of in and assign to out

endmodule