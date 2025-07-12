module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum implementation using mux-based XOR
    assign sum = a ? ~b : b;
    
    // Carry-out implementation using mux-based AND
    assign cout = a ? b : 1'b0;
endmodule