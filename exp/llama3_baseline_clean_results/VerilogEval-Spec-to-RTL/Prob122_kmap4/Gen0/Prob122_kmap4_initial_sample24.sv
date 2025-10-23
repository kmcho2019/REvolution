module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct implementation from Karnaugh map
assign out = (!c &!d & b) | 
             (c &!d & a) | 
             (c & d & b) | 
             (!c & d & a);

endmodule