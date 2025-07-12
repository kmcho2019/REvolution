module TopModule (
    input in1,
    input in2,
    output out
);
    // Transmission-gate style implementation
    assign out = (in1) ? 1'b0 : (in2 ? 1'b0 : 1'b1);
endmodule