module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    (* use_dsp48 = "no" *)  // Prevent DSP inference
    assign out_and = &in;
    
    (* keep_hierarchy = "yes" *)  // Maintain hierarchy for better optimization
    assign out_or  = |in;
    
    (* max_fanout = 4 *)  // Reasonable fanout control
    assign out_xor = ^in;

endmodule