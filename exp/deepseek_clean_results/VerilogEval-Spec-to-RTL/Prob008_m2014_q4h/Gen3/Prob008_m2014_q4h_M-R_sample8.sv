module TopModule (
    input in,
    output out
);
    buf b1(out, in);  // Using buf primitive for direct connection
endmodule