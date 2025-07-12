module TopModule (
    input a,
    input b,
    input c,
    input d,  // d remains unused
    output out
);
    wire c0_case, c1_case;
    
    // Handle c=0 cases
    assign c0_case = (~a & ~b) ? 1'b0 :  // ab=00
                    (~a & b)  ? 1'b0 :   // ab=01 (don't-care treated as 0)
                    (a & ~b)  ? 1'b1 :   // ab=10
                    1'b1;                // ab=11 (don't-care treated as 1)
    
    // Handle c=1 cases (simpler logic)
    assign c1_case = (a | b);
    
    // Final output selection
    assign out = c ? c1_case : c0_case;
endmodule