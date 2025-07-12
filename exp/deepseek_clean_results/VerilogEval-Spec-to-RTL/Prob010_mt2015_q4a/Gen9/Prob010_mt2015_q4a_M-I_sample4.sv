module TopModule (
    input x,
    input y,
    output z
);
    // Direct implementation with synthesis optimization hint
    (* use_dsp48 = "no", optimize = "true" *)
    assign z = x & ~y;
endmodule