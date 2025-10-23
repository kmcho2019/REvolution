module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Implementing the logic derived from the Karnaugh map
    assign out = ((~c & ~d & (~a & b | a & ~b)) | 
                  (c & ~d & (~a & ~b | a & b)) | 
                  (~c & d & (~a & ~b | a & b)) | 
                  (c & d & (~a & b | a & ~b)));

endmodule