module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Internal wire to handle the case when a is high and b and c are low
wire a_low_bc;

// Assign a_low_bc to be high when a is high and both b and c are low
assign a_low_bc = a && !b && !c;

// Final output q is high when b or c is high, or when a is not high and b or c is not high
assign q = (b || c) || (!a_low_bc && (b || c));

endmodule