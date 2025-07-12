module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum implementation using multiplexer logic
    assign sum = (a == b) ? 1'b0 : 1'b1;
    
    // Carry-out implementation
    assign cout = a & b;
endmodule