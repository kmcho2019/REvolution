module TopModule(
    output out
);

// Directly assign the constant value to the output port
assign out = 1'b0;

// Synthesis directive to optimize for area, as the design is simple and area-efficient
// This directive may vary depending on the synthesis tool being used
// For example, with some tools, you might use `(* area_opt *)` or similar directives
// to guide the optimizer towards area reduction.

endmodule