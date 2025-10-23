module TopModule(
    input  in1,
    input  in2,
    output out
);
// Using the same logic but ensuring synthesis tool has flexibility to optimize
assign out = in1 & (~in2);

endmodule