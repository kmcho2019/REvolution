module TopModule (
    input in,
    output out
);
    // Transmission gate style implementation
    wire en = 1'b1;  // Always enabled
    assign out = en ? in : 1'bz;
endmodule