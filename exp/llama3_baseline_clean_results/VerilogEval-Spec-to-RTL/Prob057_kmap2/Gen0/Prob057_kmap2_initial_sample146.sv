module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (d &&!c && (a || b)) || 
             (!d && c && (!a &&!b)) || 
             (!d &&!c && a &&!b) || 
             (d && c && a && b) || 
             (d && c &&!a && b) || 
             (d &&!c &&!a && b);

endmodule