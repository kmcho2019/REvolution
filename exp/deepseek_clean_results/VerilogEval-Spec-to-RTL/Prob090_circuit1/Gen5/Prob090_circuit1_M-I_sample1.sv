module TopModule (
    input a,
    input b,
    input en,  // Enable signal for power gating
    output q
);
    assign q = en ? (a & b) : 1'b0;
endmodule