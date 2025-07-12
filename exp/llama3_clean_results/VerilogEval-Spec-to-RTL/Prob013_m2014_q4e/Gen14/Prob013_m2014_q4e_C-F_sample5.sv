module TopModule(
    input  in1,
    input  in2,
    output out
);

// Use the logical NOR operator (~) to directly compute the output
// while considering PPA metrics and design simplicity
assign out = ~(in1 | in2);

endmodule