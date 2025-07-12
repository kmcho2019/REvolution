module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table parameter (16 entries for all 4-input combinations)
    parameter [15:0] TRUTH_TABLE = 16'b0000_1111_0001_1111;
    
    // Use inputs as index into truth table
    assign q = TRUTH_TABLE[{a,b,c,d}];
endmodule