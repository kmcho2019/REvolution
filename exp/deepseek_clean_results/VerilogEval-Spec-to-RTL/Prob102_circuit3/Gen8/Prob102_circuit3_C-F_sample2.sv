module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation with minimal gates
    // q is true when (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);
    
    // Note: In a larger design, consider:
    // 1. Input buffering if fanout is high
    // 2. Clock gating if inputs are stable for long periods
    // 3. Sharing this logic with similar functions
endmodule