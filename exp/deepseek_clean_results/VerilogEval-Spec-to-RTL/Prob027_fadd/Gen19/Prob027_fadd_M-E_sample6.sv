module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum remains the same - optimal XOR implementation
    assign sum = a ^ b ^ cin;
    
    // Novel carry-out implementation using mux-like logic
    assign cout = (a ^ b) ? cin : (a & b);
endmodule