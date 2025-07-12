// TopModule: A 2-to-1 multiplexer module
// Selects between input 'a' and 'b' based on 'sel'
module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Use a ternary operator for a concise implementation of the multiplexing logic
assign out = sel ? b : a;

endmodule