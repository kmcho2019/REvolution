module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Explicitly show the 5x5 comparison matrix structure
    // Row 1: a vs [a,b,c,d,e]
    assign out[24] = a ~^ a;
    assign out[23] = a ~^ b;
    assign out[22] = a ~^ c;
    assign out[21] = a ~^ d;
    assign out[20] = a ~^ e;
    
    // Row 2: b vs [a,b,c,d,e]
    assign out[19] = b ~^ a;
    assign out[18] = b ~^ b;
    assign out[17] = b ~^ c;
    assign out[16] = b ~^ d;
    assign out[15] = b ~^ e;
    
    // Row 3: c vs [a,b,c,d,e]
    assign out[14] = c ~^ a;
    assign out[13] = c ~^ b;
    assign out[12] = c ~^ c;
    assign out[11] = c ~^ d;
    assign out[10] = c ~^ e;
    
    // Row 4: d vs [a,b,c,d,e]
    assign out[9] = d ~^ a;
    assign out[8] = d ~^ b;
    assign out[7] = d ~^ c;
    assign out[6] = d ~^ d;
    assign out[5] = d ~^ e;
    
    // Row 5: e vs [a,b,c,d,e]
    assign out[4] = e ~^ a;
    assign out[3] = e ~^ b;
    assign out[2] = e ~^ c;
    assign out[1] = e ~^ d;
    assign out[0] = e ~^ e;

endmodule