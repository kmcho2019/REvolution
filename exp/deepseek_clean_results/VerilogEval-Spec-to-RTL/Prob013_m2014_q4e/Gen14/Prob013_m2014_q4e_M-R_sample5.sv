module TopModule (
    input in1,
    input in2,
    output out
);
    wire or_result;
    assign or_result = in1 | in2;
    assign out = ~or_result;
endmodule