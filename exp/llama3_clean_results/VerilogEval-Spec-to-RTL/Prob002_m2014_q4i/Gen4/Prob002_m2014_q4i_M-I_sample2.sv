module TopModule(
    output out
);
// Synthesis directive to optimize for low power and area
(* power_optimization = "low_power", area_optimization = "low_area" *)
assign out = 1'b0;

endmodule