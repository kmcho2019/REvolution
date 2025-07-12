module TopModule (
    input  in,
    output out
);
    // Explicit wire declaration for better readability
    wire out;
    
    // NOT gate implementation
    assign out = ~in;
endmodule