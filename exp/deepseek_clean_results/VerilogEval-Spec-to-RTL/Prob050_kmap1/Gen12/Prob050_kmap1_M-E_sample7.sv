module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Implement as 2:1 mux controlled by a
    // When a=0: output is ~(~b & ~c) = b|c
    // When a=1: output is 1
    assign out = a ? 1'b1 : (b | c);
endmodule