module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Create enable signals for individual bits
wire enable_o2, enable_o1, enable_o0;
assign enable_o2 = 1'b1;
assign enable_o1 = 1'b1;
assign enable_o0 = 1'b1;

// Use bitwise operations to create output vector and individual bits
assign outv = vec;
assign o2 = (vec >> 2) & enable_o2;
assign o1 = (vec >> 1) & enable_o1;
assign o0 = vec & enable_o0;

endmodule