module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire a_zero_and_bcd; // 'a' is 0 and at least one of 'b', 'c', or 'd' is 1
wire a_one_and_bc;   // 'a' is 1 and either 'b' or 'c' is 1

assign a_zero_and_bcd = ~a & (b | c | d);
assign a_one_and_bc = a & (b | c);
assign q = a_zero_and_bcd | a_one_and_bc;

endmodule