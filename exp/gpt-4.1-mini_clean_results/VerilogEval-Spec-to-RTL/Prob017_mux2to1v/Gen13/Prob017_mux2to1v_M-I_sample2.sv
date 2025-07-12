module Mux2to1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    wire [WIDTH-1:0] sel_mask     = {WIDTH{sel}};
    wire [WIDTH-1:0] inv_sel_mask = {WIDTH{~sel}};

    assign out = (a & inv_sel_mask) | (b & sel_mask);
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Slice width
    localparam SLICE_WIDTH = 10;
    // Number of slices to cover 100 bits
    localparam NUM_SLICES = 10;

    // Internal wires for slice outputs
    wire [SLICE_WIDTH-1:0] slice_out [0:NUM_SLICES-1];

    // Instantiate 10 Mux2to1 for each 10-bit slice
    genvar i;
    generate
        for (i = 0; i < NUM_SLICES; i = i + 1) begin : mux_slices
            Mux2to1 #(.WIDTH(SLICE_WIDTH)) u_mux_slice (
                .a   (a[SLICE_WIDTH*i +: SLICE_WIDTH]),
                .b   (b[SLICE_WIDTH*i +: SLICE_WIDTH]),
                .sel (sel),
                .out (slice_out[i])
            );
        end
    endgenerate

    // Concatenate slice outputs into final output
    assign out = {slice_out[9], slice_out[8], slice_out[7], slice_out[6], slice_out[5],
                  slice_out[4], slice_out[3], slice_out[2], slice_out[1], slice_out[0]};
endmodule