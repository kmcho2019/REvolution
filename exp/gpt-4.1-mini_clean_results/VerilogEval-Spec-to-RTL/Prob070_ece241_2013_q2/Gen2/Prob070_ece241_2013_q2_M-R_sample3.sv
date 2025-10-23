module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire term1_sop = na & nb & c & nd;   // corresponds to 2 (0010)
wire term2_sop = b & c & d;          // covers 7 (0111) and 15(1111)

wire clause1_pos = a | b | d;
wire clause2_pos = a | c | d;
wire clause3_pos = na | nb | c | nd;

always @(*) begin
    out_sop = term1_sop | term2_sop;
    out_pos = clause1_pos & clause2_pos & clause3_pos;
end

endmodule