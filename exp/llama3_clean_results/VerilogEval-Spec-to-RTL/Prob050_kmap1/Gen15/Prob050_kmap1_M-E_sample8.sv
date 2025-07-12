// Novel solution using a multiplexer
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Create a signal that represents the majority of b and c
wire bc_majority = b | c;

// Use a multiplexer to select between a and bc_majority
assign out = a? 1 : bc_majority;

endmodule