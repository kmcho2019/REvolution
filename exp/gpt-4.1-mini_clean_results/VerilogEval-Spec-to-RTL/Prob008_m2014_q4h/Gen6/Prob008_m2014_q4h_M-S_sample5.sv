module TopModule(input in, output out);
    // 'out' implicitly driven by 'in' through port connection; no assign needed.
    wire out = in;
endmodule