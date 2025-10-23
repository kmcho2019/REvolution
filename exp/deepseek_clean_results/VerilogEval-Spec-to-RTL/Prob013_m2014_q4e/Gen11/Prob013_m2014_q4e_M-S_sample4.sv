module TopModule (
    input  in1,
    input  in2,
    output out
);
    assign out = ~(in1 | in2);  // 2-input NOR gate
endmodule