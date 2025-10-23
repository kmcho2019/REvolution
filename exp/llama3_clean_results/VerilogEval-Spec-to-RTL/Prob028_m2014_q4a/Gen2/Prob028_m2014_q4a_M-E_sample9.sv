module TopModule(
    input  d,
    input  ena,
    output q
);

// Using two NOR gates to implement a D latch
wire not_q;
assign q = ~(ena & d | not_q);
assign not_q = ~(ena & d | q);

endmodule