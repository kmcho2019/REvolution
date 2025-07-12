module TopModule (
    output zero
);
    // Using a NOT gate to produce a constant LOW output.
    // The input to the NOT gate is tied to a constant HIGH (1).
    assign zero = ~1'b1;
    
    // This approach is functionally equivalent to the direct assignment
    // but illustrates the use of a logical operation to achieve the result.
endmodule