module TopModule (
    input in,
    output out
);
    // LUT1 configured as buffer (truth table: 2'b01)
    LUT1 #(
        .INIT(2'b01)
    ) buffer_lut (
        .I0(in),
        .O(out)
    );
endmodule