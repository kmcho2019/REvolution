module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement out = in1 & ~in2 using a 2:1 multiplexer
    assign out = in2 ? 1'b0 : in1;
endmodule