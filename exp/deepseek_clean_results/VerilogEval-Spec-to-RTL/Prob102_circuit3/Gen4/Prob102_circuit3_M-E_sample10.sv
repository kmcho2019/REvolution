module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // First pair check: at least one of a or b is high
    wire first_pair_ok = (a || b);
    
    // Second pair check: at least one of c or d is high
    wire second_pair_ok = (c || d);
    
    // Final output is consensus of both pairs
    assign q = first_pair_ok && second_pair_ok;

endmodule