module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);
    // Using a synthesis attribute to optimize for area, if supported by the synthesis tool
    (* synthesize = "yes" *)
    (* area_optimization = "high" *)
    assign one = OUTPUT_VALUE;
endmodule