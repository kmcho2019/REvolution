module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_val;
    assign xnor_val = ~(in1 ^ in2);
    assign out = xnor_val ^ in3;

endmodule