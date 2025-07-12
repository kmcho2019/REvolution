module TopModule(
    input  in1,
    input  in2,
    output out
);
// Direct implementation of a 2-input NOR gate using logical operators
assign out = ~(in1 | in2);
endmodule