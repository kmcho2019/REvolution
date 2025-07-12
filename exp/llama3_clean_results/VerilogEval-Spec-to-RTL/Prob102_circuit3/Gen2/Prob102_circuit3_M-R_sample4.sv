module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire or_result;  // Intermediate variable for (a or c)
wire and_result; // Intermediate variable for ((a or c) and d)

assign or_result = a || c;
assign and_result = or_result && d;

assign q = b || and_result;

endmodule