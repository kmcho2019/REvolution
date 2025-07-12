module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Define the 4 functions for each ab combination
wire f_ab00, f_ab01, f_ab11, f_ab10;

// ab = 00: out = ~(c & d)
assign f_ab00 = ~(c & d);

// ab = 01: out = ~(c ^ d)
assign f_ab01 = ~(c ^ d);

// ab = 11: out = c | d
assign f_ab11 = c | d;

// ab = 10: out = ~(c & ~d)
assign f_ab10 = ~(c & ~d);

// 4:1 Mux to select the appropriate function
assign out = (~b & ~a) ? f_ab00 :
             (~b &  a) ? f_ab01 :
             ( b &  a) ? f_ab11 :
             /*default*/ f_ab10;

endmodule