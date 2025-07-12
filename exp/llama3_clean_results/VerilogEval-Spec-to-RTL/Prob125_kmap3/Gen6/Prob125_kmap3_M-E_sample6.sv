module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the logic using a multiplexer and logic gates
wire cond_out; // Output of the condition !b && c
assign cond_out = ~b & c;

// Using a 2-to-1 multiplexer to select between the constant 1 and cond_out based on a
assign out = a ? 1'b1 : cond_out;

endmodule