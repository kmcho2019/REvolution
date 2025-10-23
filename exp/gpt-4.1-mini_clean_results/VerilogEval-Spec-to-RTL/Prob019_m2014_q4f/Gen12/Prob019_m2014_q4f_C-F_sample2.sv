module TopModule (
    input  in1,
    input  in2,
    output out
);
    // out = in1 AND (NOT in2); implementing an AND gate with a bubble on in2
    assign out = in1 & ~in2;
endmodule