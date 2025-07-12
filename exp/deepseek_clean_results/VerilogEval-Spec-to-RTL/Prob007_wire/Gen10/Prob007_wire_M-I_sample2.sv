module TopModule (
    input in,
    output out
);
    // This is already the optimal implementation
    assign out = in;
    
    // Alternative implementations would be worse:
    // buf(out, in);  // Gate-level primitive (no better)
    // assign out = in /* synthesis keep */;  // Unnecessary attribute
endmodule