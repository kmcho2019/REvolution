module TopModule (
    input in,
    output out
);
    wire intermediate;  // Explicit wire declaration
    
    assign intermediate = in;
    assign out = intermediate;
endmodule