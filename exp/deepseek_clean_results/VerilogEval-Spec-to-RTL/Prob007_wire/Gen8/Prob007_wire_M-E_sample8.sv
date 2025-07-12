module TopModule (
    input in,
    output out
);
    // Transmission gate style implementation
    wire tg_control = 1'b1;  // Always enabled
    assign out = tg_control ? in : 1'bz;
endmodule