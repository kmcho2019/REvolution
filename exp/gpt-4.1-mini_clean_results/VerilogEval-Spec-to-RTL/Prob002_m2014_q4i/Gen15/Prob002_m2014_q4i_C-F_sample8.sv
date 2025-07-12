module TopModule (
    output wire out
);

// Synthesis directive to indicate constant 0 tied to ground (tool-specific, here generic)
(* keep = "true", dont_touch = "true" *) wire const_zero = 1'b0;

assign out = const_zero;

endmodule