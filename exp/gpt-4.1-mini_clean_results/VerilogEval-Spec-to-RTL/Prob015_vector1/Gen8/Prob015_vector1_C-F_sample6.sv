module ByteSplitter16 (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Direct slicing ensures zero added logic and minimal delay/power/area
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the modular splitter that performs direct slicing
    ByteSplitter16 splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule