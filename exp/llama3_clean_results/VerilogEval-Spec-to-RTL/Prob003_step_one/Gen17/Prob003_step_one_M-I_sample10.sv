// TopModule: Always drives output 'one' high, with consideration for synthesis optimization.
module TopModule(
    output one
);

// Directly assign the constant value 1 to the output 'one', with synthesis attribute for area optimization.
(* areaoptimize = "yes" *) assign one = 1'b1;

endmodule