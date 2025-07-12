module TopModule (
    input a,
    input b,
    output out
);
    wire or_out;
    
    // First stage: OR gate
    assign or_out = a | b;
    
    // Second stage: NOT gate (NOR operation)
    assign out = ~or_out;
endmodule