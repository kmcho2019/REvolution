module ByteSplitterTristate (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    wire en_hi, en_lo;
    assign en_hi = 1'b1;
    assign en_lo = 1'b1;

    // Use tri-state buffers for each byte segment
    assign out_hi = en_hi ? in[15:8] : 8'bz;
    assign out_lo = en_lo ? in[7:0]  : 8'bz;

endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Instantiate the tri-state-based byte splitter
    ByteSplitterTristate splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
endmodule