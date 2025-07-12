module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement in1 & ~in2 using a multiplexer
    assign out = in1 ? ~in2 : 1'b0;
endmodule