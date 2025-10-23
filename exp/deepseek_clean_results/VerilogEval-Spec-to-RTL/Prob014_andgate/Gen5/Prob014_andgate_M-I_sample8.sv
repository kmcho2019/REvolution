(* use_dsp48 = "no" *)  // Prevent synthesis tool from using DSP blocks for simple logic
module TopModule(
    input  wire a,    // Explicit wire declaration
    input  wire b,
    output wire out
);
    // Continuous assignment for optimal 2-input AND implementation
    // with explicit timing constraint for critical paths
    (* keep = "true" *) assign out = a & b;  // Prevent optimization removal
    
    // Alternative implementation comment for reference:
    // For some technologies, this might yield better results:
    // assign out = ~(~a | ~b);  // AND using De Morgan's laws
endmodule