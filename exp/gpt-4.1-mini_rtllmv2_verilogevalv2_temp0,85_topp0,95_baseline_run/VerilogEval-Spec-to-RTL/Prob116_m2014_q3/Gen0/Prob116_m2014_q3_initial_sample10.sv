module TopModule(input [3:0] x, output f);
    // Mapping inputs to the Karnaugh map variables:
    // x[4] = x[3]
    // x[3] = x[2]
    // x[2] = x[1]
    // x[1] = x[0]
    // Rows: x[3]x[4] => x[2]x[3]
    // Cols: x[1]x[2] => x[0]x[1]
    
    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];
    
    // Karnaugh map (rows x4 x3, columns x1 x2):
    //    00   01   11   10
    // 00 d(0) 0    d(0) d(0)
    // 01 0    d(0) 1    0
    // 11 1    1    d(0) d(0)
    // 10 1    1    0    d(0)
    //
    // We assign don't cares as 0 where convenient for simplification.
    
    // Let's build the truth table f(x4,x3,x2,x1):
    // x4 x3 x2 x1 | f
    // 0  0  0  0  | d=0
    // 0  0  0  1  | 0
    // 0  0  1  1  | d=0
    // 0  0  1  0  | d=0
    // 0  1  0  0  | 0
    // 0  1  0  1  | d=0
    // 0  1  1  1  | 1
    // 0  1  1  0  | 0
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  1  | d=0
    // 1  1  1  0  | d=0
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  1  | 0
    // 1  0  1  0  | d=0
    
    // Implement the function as a combinational logic from the truth table:
    
    assign f = 
        // From the map, grouping ones:
        // Group1: x4=1, x3=1, x2=0 or 1, x1=0 or 1 except x2=1 x1=1 is d=0
        // Group2: x4=1, x3=0, x2=0, x1=0 or 1 (1 0 0 0 and 1 0 0 1)
        // Group3: x4=0, x3=1, x2=1, x1=1 (0 1 1 1)
        // Group4: x4=1, x3=1, x2=0, x1=0 and 1
        // Summarizing:
        // f = (x4 & x3 & ~x2) | (x4 & ~x3 & ~x2) | (~x4 & x3 & x2 & x1)
        (x4 & x3 & ~x2) | (x4 & ~x3 & ~x2) | (~x4 & x3 & x2 & x1);
endmodule