module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire q_a0;  // output when a is 0
wire q_a1;  // output when a is 1

// logic for a = 0
assign q_a0 = b | c | d;

// logic for a = 1
assign q_a1 = b | c;

// multiplexer to select output based on a
assign q = a ? q_a1 : q_a0;

endmodule