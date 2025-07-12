module TopModule (
    input a,
    input b,
    output out
);
    (* use_dsp48 = "no" *)  // Prevent tool from using DSP blocks
    assign out = a ^~ b;
endmodule