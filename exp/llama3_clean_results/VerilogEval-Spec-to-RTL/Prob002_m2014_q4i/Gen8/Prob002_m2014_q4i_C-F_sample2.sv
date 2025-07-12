module TopModule(
    output out
);

// Directly assign the constant value to the output port
// Incorporating a synthesis directive for area optimization
(* area_opt *)
assign out = 1'b0;

endmodule