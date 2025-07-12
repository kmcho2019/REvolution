module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out // Output is a reg type to be used within always block
);

// Define the combinational logic within an always block
always @(*) begin
    // Implement the required logic from the Karnaugh map
    out = a | (~a & ~b & c);
end

endmodule