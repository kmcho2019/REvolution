module TopModule(
    input a,
    input b,
    input c,
    output out
);
    
    // The Karnaugh map indicates the output should be 1 if any of the inputs a, b, or c is 1.
    // This is directly implemented using an always block for a different structural approach.
    always @(*) begin
        out = a | b | c;
    end

endmodule