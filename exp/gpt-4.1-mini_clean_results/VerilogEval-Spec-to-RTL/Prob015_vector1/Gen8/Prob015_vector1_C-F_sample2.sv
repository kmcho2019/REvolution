module Splitter8 (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Combinational assignment to split the input vector into high and low bytes
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the Splitter8 module for clean modular splitting
    Splitter8 splitter_inst (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule