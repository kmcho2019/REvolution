module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(ena or d)
    if (ena) 
        q = d;
    // Else do nothing, retain the previous value of q

endmodule