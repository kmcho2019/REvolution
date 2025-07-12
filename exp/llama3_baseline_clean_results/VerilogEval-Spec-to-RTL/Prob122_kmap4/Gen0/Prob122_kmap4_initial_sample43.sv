module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Directly implement the Karnaugh map logic
assign out = (
    // cd=00 and (ab=01 or ab=10)
    (!c &!d & (a &!b)) ||
    (!c &!d & (!a & b)) ||
    
    // cd=01 and (ab=00 or ab=11)
    (!c & d & (!a &!b)) ||
    (!c & d & (a & b)) ||
    
    // cd=11 and (ab=01 or ab=10)
    (c & d & (a &!b)) ||
    (c & d & (!a & b)) ||
    
    // cd=10 and (ab=00 or ab=11)
    (c &!d & (!a &!b)) ||
    (c &!d & (a & b))
);

endmodule