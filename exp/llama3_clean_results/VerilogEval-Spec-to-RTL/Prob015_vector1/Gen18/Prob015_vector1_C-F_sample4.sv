// Define a parameterizable module for the input splitting logic
module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Directly assign the input bits to the output ports for efficiency and simplicity
    assign {out_hi, out_lo} = in;

endmodule

// Example instantiation of TopModule
module main(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate TopModule with the desired parameters
    TopModule #(
        .INPUT_WIDTH(16),
        .SPLIT_POINT(8)
    ) splitter(
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule