module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    /* 5x5 Comparison Matrix (25 bits total)
       Each row compares one input against all inputs (including itself)
       Bit order: [24:20] = a vs [a,b,c,d,e]
                  [19:15] = b vs [a,b,c,d,e]
                  [14:10] = c vs [a,b,c,d,e]
                  [ 9: 5] = d vs [a,b,c,d,e]
                  [ 4: 0] = e vs [a,b,c,d,e] */
    
    // Row-wise assignments using direct XNOR operations
    assign out[24:20] = {a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e};
    assign out[19:15] = {b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e};
    assign out[14:10] = {c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e};
    assign out[ 9: 5] = {d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e};
    assign out[ 4: 0] = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e};

endmodule