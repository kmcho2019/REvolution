// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output reg out  // Output
);

// Implement a 2-to-1 multiplexer using a ternary operator within an always block
always @(*) begin
    out = sel ? b : a;
end

endmodule