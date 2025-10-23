module TopModule(
    input  in1,
    input  in2,
    output reg out
);
    always @(*)
        out = ~(in1 | in2);
endmodule