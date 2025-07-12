module TopModule (
    input in,
    output out
);
    // Implement as a 1-input LUT configured as buffer
    // LUT1 initialization value = 2'b01 (output equals input)
    LUT1 #(
        .INIT(2'b01)
    ) lut_buffer (
        .I0(in),
        .O(out)
    );
endmodule