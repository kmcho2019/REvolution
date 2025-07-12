module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Synthesis directive to optimize for area and power
// `synthesize -area -power`

// Applying a synthesis attribute to optimize the logic
(* area_opt = "true" *) 
(* power_opt = "true" *)
assign out = a | (~a & ~b & c);

endmodule