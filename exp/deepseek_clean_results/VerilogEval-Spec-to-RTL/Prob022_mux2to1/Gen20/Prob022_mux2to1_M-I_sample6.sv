(* use_dsp48 = "no", optimize_power *)
module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Simple 2:1 mux - sel=0: a, sel=1: b
    assign out = sel ? b : a;
endmodule