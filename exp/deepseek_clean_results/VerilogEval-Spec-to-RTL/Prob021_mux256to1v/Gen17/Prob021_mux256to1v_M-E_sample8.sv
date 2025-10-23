module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Recursive binary tree mux implementation
    mux_tree #(.DEPTH(8)) tree (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule

module mux_tree #(
    parameter DEPTH = 0
) (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    generate
        if (DEPTH == 0) begin
            // Leaf node - select 4-bit slice
            assign out = in[sel[7:0]*4 +: 4];
        end else begin
            // Internal node - instantiate two child muxes
            wire [3:0] left_out, right_out;
            
            mux_tree #(.DEPTH(DEPTH-1)) left (
                .in(in),
                .sel(sel),
                .out(left_out)
            );
            
            mux_tree #(.DEPTH(DEPTH-1)) right (
                .in(in),
                .sel(sel),
                .out(right_out)
            );
            
            // Select between children based on current depth's selector bit
            assign out = sel[DEPTH-1] ? right_out : left_out;
        end
    endgenerate

endmodule