module TwoToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

// Recursive parameterized mux tree for N-to-1 mux, N must be a power of two
module MuxNto1_Tree #(parameter N = 2, parameter SEL_WIDTH = 1) (
    input  wire [N-1:0] in,
    input  wire [SEL_WIDTH-1:0] sel,
    output wire out
);
    generate
        if (N == 2) begin : base_case
            // Base case: 2-to-1 mux directly instantiation
            TwoToOneMux mux (
                .in0(in[0]),
                .in1(in[1]),
                .sel(sel[0]),
                .out(out)
            );
        end else begin : recursive_case
            localparam HALF = N/2;
            localparam HALF_SEL_WIDTH = SEL_WIDTH - 1;

            wire lower_out;
            wire upper_out;

            // Lower half mux
            MuxNto1_Tree #(
                .N(HALF),
                .SEL_WIDTH(HALF_SEL_WIDTH)
            ) lower_mux (
                .in(in[HALF-1:0]),
                .sel(sel[HALF_SEL_WIDTH-1:0]),
                .out(lower_out)
            );

            // Upper half mux
            MuxNto1_Tree #(
                .N(HALF),
                .SEL_WIDTH(HALF_SEL_WIDTH)
            ) upper_mux (
                .in(in[N-1:HALF]),
                .sel(sel[HALF_SEL_WIDTH-1:0]),
                .out(upper_out)
            );

            // Select between lower and upper half mux outputs using MSB of sel
            TwoToOneMux top_mux (
                .in0(lower_out),
                .in1(upper_out),
                .sel(sel[SEL_WIDTH-1]),
                .out(out)
            );
        end
    endgenerate
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Instantiate the recursive 256-to-1 mux tree directly
    MuxNto1_Tree #(
        .N(256),
        .SEL_WIDTH(8)
    ) mux256to1 (
        .in(in),
        .sel(sel),
        .out(out)
    );
endmodule