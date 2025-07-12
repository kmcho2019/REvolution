module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Directly implement the logic based on the observed conditions
// q is high when b or c is high, or when a is low and (b or c) is high
assign q = (b || c) || (!a && (b || c));

// However, this can be further simplified based on the truth table:
// q is high if b or c is high, regardless of a and d.
// q is also low if a is high and both b and c are low, which is covered by the first condition.
assign q = b || c;

endmodule