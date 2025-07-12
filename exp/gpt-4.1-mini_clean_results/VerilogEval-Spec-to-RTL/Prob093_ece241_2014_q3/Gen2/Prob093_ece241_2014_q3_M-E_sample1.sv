module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

// Implement 2-to-1 mux primitive function:
// mux2(sel, in0, in1) = sel ? in1 : in0
function automatic mux2;
    input sel, in0, in1;
    begin
        mux2 = sel ? in1 : in0;
    end
endfunction

// From the K-map, for each mux_in[i]:

// ab = 00 -> mux_in[0]
// For cd: 00=0, 01=1, 11=1, 10=1
// Truth table wrt c,d:
// c d | out
// 0 0 | 0
// 0 1 | 1
// 1 1 | 1
// 1 0 | 1
// Expression: When c=0, output = d; when c=1, output=1
wire mux_in_0 = mux2(c, d, 1'b1);

// ab = 01 -> mux_in[1]
// For cd: 00=0, 01=0, 11=0, 10=0 -> always 0
wire mux_in_1 = 1'b0;

// ab = 11 -> mux_in[2]
// For cd: 00=0,01=0,11=1,10=0
// c d | out
// 0 0 | 0
// 0 1 | 0
// 1 1 | 1
// 1 0 | 0
// This is c AND d -> implement with mux using c or d
// mux2(c, 0, d) = if c=0 ->0 else d
wire mux_in_2 = mux2(c, 1'b0, d);

// ab = 10 -> mux_in[3]
// For cd: 00=1,01=0,11=1,10=1
// c d | out
// 0 0 | 1
// 0 1 | 0
// 1 1 | 1
// 1 0 | 1
// Expression:
// When c=0: out=d' (not d)
// When c=1: out=1
// Since NOT d not allowed as gate, implement NOT d using mux with d as selector and constant inputs:
// not_d = mux2(d,1,0)
// So:
// mux_in_3 = mux2(c, not_d, 1)
wire not_d = mux2(d, 1'b1, 1'b0);
wire mux_in_3 = mux2(c, not_d, 1'b1);

assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};

endmodule