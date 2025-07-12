module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (!c & (!a | !b)) | (!d & !a & (!b | b)) | (c & d & (a | b));

endmodule