module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Attribute to guide synthesis tool for area optimization
(* area_optimization = "high" *)
// Attribute to guide synthesis tool for power optimization
(* power_optimization = "high" *)
assign out = a | b | c;

endmodule