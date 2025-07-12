module TopModule(
    input  in1,
    input  in2,
    output out
);
// Implementing a 2-input NOR gate
assign out = ~(in1 | in2);
endmodule