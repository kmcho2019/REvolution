module ParamMux #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);
    wire [WIDTH-1:0] mux_tree [0:$clog2(WIDTH)];

    assign mux_tree[0] = in;
    
    generate
        genvar level, bit;
        for (level = 0; level < $clog2(WIDTH); level = level + 1) begin : mux_level
            for (bit = 0; bit < (WIDTH >> (level + 1)); bit = bit + 1) begin : mux_bit
                assign mux_tree[level + 1][bit] = sel[level] ? 
                    mux_tree[level][(bit << 1) + 1] : 
                    mux_tree[level][bit << 1];
            end
        end
    endgenerate

    assign out = mux_tree[$clog2(WIDTH)][0];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule