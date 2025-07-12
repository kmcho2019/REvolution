module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Original: next_y1 = (y[0] & ~y[1]) | ((~y[0]) & w & (y[1] | y[2]));
    // Factor common terms for simplification:
    // next_y1 = y[0]&~y[1] | ~y[0]&w&(y[1]|y[2])
    // = y[0]&~y[1] | (~y[0]&w&y[1]) | (~y[0]&w&y[2])
    // Consider factoring (y[0]&~y[1]) and (~y[0]&w&y[1]) terms into a MUX like structure
    // Or rearranged as: next_y1 = y[1] ? (~y[0]&w) : (y[0])
    // Let's verify logic:
    // When y[1]=1: next_y1 = (~y[0]&w)
    // When y[1]=0: next_y1 = y[0]
    // That covers the first two terms combined with y[2] condition in original? 
    // But original has y[2] term only when y[1] is 0 or 1? Check original carefully.
    // The original has OR with (y[1] | y[2]) for the w & ~y[0] term.
    // So if y[1]=1 or y[2]=1, and w=1 & y[0]=0 => next_y1=1
    // The simplified MUX-like logic doesn't fully cover y[2].
    // Let's try: next_y1 = (y[1] | y[2]) ? (~y[0]&w) : (y[0]&~y[1])
    // Test example: y=000 (A), w=0 -> next_y1=0
    // y=001 (B), w=1 -> (y[1]|y[2])=1, (~y[0]&w)=1 => next_y1=1 correct.
    // So this expression is valid and simpler:
    assign Y1 = ((y[1] | y[2]) & (~y[0]) & w) | (y[0] & (~y[1]));

endmodule