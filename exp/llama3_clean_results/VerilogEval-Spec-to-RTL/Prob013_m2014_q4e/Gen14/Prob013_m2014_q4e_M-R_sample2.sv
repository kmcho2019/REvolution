module TopModule(
    input  in1,
    input  in2,
    output out
);
// Implementation of a 2-input NOR gate using continuous assignment
assign out = ~(in1 | in2);
endmodule