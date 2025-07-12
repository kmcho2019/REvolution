module TopModule (
    input in,
    output out
);
    // LUT1 configured as a buffer (wire)
    LUT1 #(
        .INIT(2'b01)  // Truth table: 0->0, 1->1
    ) lut_inst (
        .I0(in),
        .O(out)
    );
endmodule