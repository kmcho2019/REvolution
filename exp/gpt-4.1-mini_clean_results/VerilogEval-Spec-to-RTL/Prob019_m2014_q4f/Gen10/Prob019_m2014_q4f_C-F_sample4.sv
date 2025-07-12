module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Implement the AND gate with a bubble on in2 using inline logic
    assign out = in1 & ~in2;
endmodule