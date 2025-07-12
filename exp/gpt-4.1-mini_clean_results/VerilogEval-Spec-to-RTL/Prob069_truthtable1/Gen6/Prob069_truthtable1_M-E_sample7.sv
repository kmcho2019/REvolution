module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

wire nx3, nx2, nx1;
wire m0, m1, m2, m3, m4, m5, m6, m7;

// Invert inputs
assign nx3 = ~x3;
assign nx2 = ~x2;
assign nx1 = ~x1;

// 3-to-8 decoder minterms
assign m0 = nx3 & nx2 & nx1; // 000
assign m1 = nx3 & nx2 &  x1; // 001
assign m2 = nx3 &  x2 & nx1; // 010
assign m3 = nx3 &  x2 &  x1; // 011
assign m4 =  x3 & nx2 & nx1; // 100
assign m5 =  x3 & nx2 &  x1; // 101
assign m6 =  x3 &  x2 & nx1; // 110
assign m7 =  x3 &  x2 &  x1; // 111

// OR the minterms that correspond to f=1 from the truth table
assign f = m2 | m3 | m5 | m7;

endmodule