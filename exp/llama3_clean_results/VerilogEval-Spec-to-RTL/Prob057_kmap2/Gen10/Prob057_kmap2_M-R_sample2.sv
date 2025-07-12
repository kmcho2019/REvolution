module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab00, ab01, ab11, ab10; // Conditions for ab
wire cd00, cd01, cd11, cd10; // Conditions for cd

assign ab00 = (!a && !b);
assign ab01 = (!a &&  b);
assign ab11 = ( a &&  b);
assign ab10 = ( a && !b);

assign cd00 = (!c && !d);
assign cd01 = (!c &&  d);
assign cd11 = ( c &&  d);
assign cd10 = ( c && !d);

assign out = (ab00 && (cd00 || cd01 || cd10)) ||
             (ab01 && (cd00 || cd11)) ||
             (ab11 && (cd01 || cd11)) ||
             (ab10 && cd00);

endmodule