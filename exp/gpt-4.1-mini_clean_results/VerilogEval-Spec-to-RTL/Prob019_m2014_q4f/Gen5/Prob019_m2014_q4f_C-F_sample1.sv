module TopModule (
    input  in1,
    input  in2,
    output out
);

wire inv_in2 = ~in2;
assign out = in1 & inv_in2;

endmodule