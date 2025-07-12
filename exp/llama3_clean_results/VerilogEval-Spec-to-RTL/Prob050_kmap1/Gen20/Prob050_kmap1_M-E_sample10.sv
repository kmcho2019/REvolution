module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Separate logic paths for 'a' and 'b or c'
wire b_or_c;
assign b_or_c = b | c;

// Combine the two logic paths
assign out = a | b_or_c;

endmodule