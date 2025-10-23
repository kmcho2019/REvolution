module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Define an intermediate signal to represent the condition where 'b' or 'c' is 1
wire bc_or;

assign bc_or = b | c;
assign out = a | bc_or;

endmodule