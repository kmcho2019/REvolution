module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct wiring for optimal PPA
    assign outv = vec;
    assign {o2, o1, o0} = vec;  // Alternative concise syntax for bit assignments

endmodule