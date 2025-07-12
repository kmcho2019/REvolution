module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // a compared with all inputs (including self)
    assign out[24:20] = {a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e};
    
    // b compared with all inputs
    assign out[19:15] = {b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e};
    
    // c compared with all inputs
    assign out[14:10] = {c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e};
    
    // d compared with all inputs
    assign out[9:5]   = {d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e};
    
    // e compared with all inputs
    assign out[4:0]   = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e};

endmodule