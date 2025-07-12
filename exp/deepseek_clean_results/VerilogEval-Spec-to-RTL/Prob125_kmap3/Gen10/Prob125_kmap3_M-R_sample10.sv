module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    wire a_high = a;
    wire bc_case = ~b & c;
    
    assign out = a_high | bc_case;
endmodule