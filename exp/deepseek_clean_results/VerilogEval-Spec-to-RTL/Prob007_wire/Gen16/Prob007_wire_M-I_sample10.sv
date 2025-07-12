module TopModule (
    input in,
    output out
);
    (* keep = "true" *)  // Optional synthesis attribute to prevent optimization
    assign out = in;     // Direct continuous assignment remains optimal
endmodule