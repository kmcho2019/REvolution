module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Local ByteSplitter module encapsulated within TopModule
    // Performs direct bit slicing without parameters or extra logic
    module ByteSplitter (
        input  [15:0] in,
        output [7:0] out_hi,
        output [7:0] out_lo
    );
        assign out_hi = in[15:8];
        assign out_lo = in[7:0];
    endmodule

    // Instantiate the local ByteSplitter to split input into high and low bytes
    ByteSplitter splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule