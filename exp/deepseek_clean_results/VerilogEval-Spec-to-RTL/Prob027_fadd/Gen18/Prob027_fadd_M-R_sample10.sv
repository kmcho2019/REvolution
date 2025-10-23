module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Compute both outputs in one assignment using concatenation
    assign {cout, sum} = {(a & b) | (a & cin) | (b & cin), a ^ b ^ cin};
endmodule