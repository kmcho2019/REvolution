module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xnor_stage;
    assign xnor_stage = in1 ~^ in2;
    assign out = xnor_stage ^ in3;
endmodule