// TopModule implements a simple AND gate.
// The output q is 1 only when both inputs a and b are 1.
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    output reg q  // Output q
);

// Using a combinational always block for flexibility and simplicity
always @(*) begin
    // Perform the AND operation
    q = a & b;
end

endmodule