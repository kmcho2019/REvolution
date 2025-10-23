module TopModule(
    input a,
    input b,
    input c,
    input d,  // d is unused as per waveform analysis
    output q
);
    assign q = (a & (b | c)) | (~a & b & c);
endmodule