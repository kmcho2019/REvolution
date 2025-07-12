module TopModule (
    input  in1,    // First input
    input  in2,    // Second input
    output out     // NOR output
);
    // 2-input NOR gate implementation
    assign out = ~(in1 | in2);
    // Alternative syntax: assign out = in1 ~| in2;
endmodule