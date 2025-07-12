module TopModule (
    input  in1,
    input  in2,
    output out
);

// Output the NOR of in1 and in2 using a direct bitwise NOR operation
assign out = ~(in1 | in2);

endmodule