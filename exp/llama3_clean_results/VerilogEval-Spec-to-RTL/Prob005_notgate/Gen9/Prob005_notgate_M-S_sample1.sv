module TopModule(
    input  in,
    output out
);

// Using continuous assignment for a NOT gate
assign out = ~in;

endmodule