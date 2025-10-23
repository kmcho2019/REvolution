module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Decision tree implementation
wire cd00, cd01, cd11, cd10;
wire ab00, ab01, ab11, ab10;

// First level: CD decoding
assign cd00 = ~c & ~d;
assign cd01 = ~c & d;
assign cd11 = c & d;
assign cd10 = c & ~d;

// Second level: AB decoding
assign ab00 = ~a & ~b;
assign ab01 = ~a & b;
assign ab11 = a & b;
assign ab10 = a & ~b;

// Output decision tree
assign out = (cd00 & (ab00 | ab01 | ab10)) |  // CD=00 cases
             (cd01 & (ab00 | ab10)) |          // CD=01 cases
             (cd11 & (ab01 | ab11 | ab10)) |   // CD=11 cases
             (cd10 & ab00);                    // CD=10 cases

endmodule