module TopModule (
    input  in1,
    input  in2,
    output out
);

// out implements AND gate with bubble (inversion) on in2 input
// Logic: out = in1 AND (NOT in2)
assign out = in1 & ~in2;

endmodule