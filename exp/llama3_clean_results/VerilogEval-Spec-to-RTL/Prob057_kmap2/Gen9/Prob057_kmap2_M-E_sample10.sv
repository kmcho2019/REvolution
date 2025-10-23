module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab, cd, ab_not, cd_not;
assign ab = a & b;
assign cd = c & d;
assign ab_not = ~(a | b);
assign cd_not = ~(c | d);

assign out = (ab_not & cd_not) | 
             (ab & cd_not) | 
             (ab_not & cd) | 
             (ab & cd);

endmodule