module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

// Specifying optimization for area
(* area = "yes" *)
assign out = a || b || c;

endmodule