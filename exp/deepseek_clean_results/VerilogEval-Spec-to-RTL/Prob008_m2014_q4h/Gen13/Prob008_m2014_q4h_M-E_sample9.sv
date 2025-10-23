module TopModule (
    input in,
    output out
);
    wire intermediate;  // Explicit wire declaration
    
    assign intermediate = in;  // Intermediate assignment
    assign out = intermediate;  // Final assignment
endmodule