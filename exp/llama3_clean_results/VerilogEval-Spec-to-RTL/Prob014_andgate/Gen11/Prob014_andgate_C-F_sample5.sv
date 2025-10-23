// TopModule: Demonstrates two methods for implementing a 2-input AND gate
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out_direct, // Output using direct assignment
    output logic out_always  // Output using always block
);

// Method 1: Using continuous assignment for direct implementation
assign out_direct = a & b; // Direct AND operation assignment

// Method 2: Using an always block for a more procedural approach
always @(*) begin
    out_always = a & b; // Perform AND operation and assign to out_always
end

endmodule